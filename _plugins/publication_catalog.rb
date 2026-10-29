# Build the publications page and citation downloads from the same BibTeX sources
# used by jekyll-scholar. Site-only fields never enter the exported citations.
require "bibtex"
require "json"
require "fileutils"

module Jekyll
  # Citation exports are data files, not pages. In particular, jekyll-scholar's
  # BibTeX converter must never turn a downloadable .bib into formatted HTML.
  class PublicationDownload < StaticFile
    def initialize(site, filename, content)
      super(site, site.source, "assets/bibliography", filename)
      @content = content.encode(Encoding::UTF_8)
      @modified_time = Time.now
    end

    def modified_time
      @modified_time
    end

    def write(dest)
      dest_path = destination(dest)
      FileUtils.mkdir_p(File.dirname(dest_path))
      # Binary mode preserves exact RIS CRLF endings on Windows as well as Unix.
      File.binwrite(dest_path, @content)
      true
    end
  end

  class PublicationCatalog < Generator
    safe true
    priority :normal

    SOURCES = {
      "papers.bib" => "article",
      "preprints.bib" => "preprint",
      "thesis.bib" => "thesis"
    }.freeze
    STANDARD_FIELDS = %i[
      title author editor journal booktitle volume number pages year month day
      publisher address edition series chapter school institution type doi url
      eprint archiveprefix primaryclass note isbn issn
    ].freeze
    VERIFIED_ON = "2026-10-29".freeze

    def generate(site)
      items = SOURCES.flat_map do |filename, kind|
        path = File.join(site.source, "_bibliography", filename)
        next [] unless File.file?(path)

        source = File.read(path, encoding: "UTF-8").sub(/\A(?:\uFEFF)?---[ \t]*\r?\n.*?^---[ \t]*(?:\r?\n|\z)/m, "")
        bibliography = BibTeX.parse(source)
        bibliography.replace_strings
        bibliography.entries.values.map { |entry| publication(entry, kind) }
      end
      items.sort_by! { |item| [-item["year"].to_i, -item["month"], -item["day"], item["title"]] }

      duplicate = items.group_by { |item| item["id"] }.find { |_, group| group.length > 1 }
      raise Errors::FatalException, "Duplicate publication identifier: #{duplicate.first}" if duplicate

      counts = %w[article abstract preprint thesis].to_h { |kind| [kind, items.count { |item| item["kind"] == kind }] }
      counts["total"] = items.length
      site.data["publication_catalog"] = {
        "items" => items,
        "years" => items.map { |item| item["year"] }.uniq.sort_by(&:to_i).reverse,
        "counts" => counts,
        "updated" => site.config.fetch("publications_updated", VERIFIED_ON)
      }

      items.each do |item|
        download(site, "#{item['id']}.bib", item["bibtex"])
        download(site, "#{item['id']}.ris", item["ris"])
      end
      download(site, "all-publications.bib", items.map { |item| item["bibtex"] }.join("\n"))
      download(site, "all-publications.ris", items.map { |item| item["ris"] }.join("\n"))
    end

    private

    def publication(entry, source_kind)
      # Conversion handles both legacy LaTeX names and native UTF-8 metadata.
      entry.convert!(:latex)
      csl = entry.to_citeproc
      field = ->(name) { entry[name]&.to_s&.strip.to_s }
      id = entry.key.downcase.gsub(/[^a-z0-9-]+/, "-").gsub(/\A-+|-+\z/, "")
      kind = source_kind
      kind = field.call(:kind) if %w[article abstract preprint thesis].include?(field.call(:kind))
      type_label = case kind
                   when "preprint" then "Preprint"
                   when "abstract" then "Conference abstract"
                   when "thesis"
                     entry.type == :mastersthesis ? "Master’s thesis" : "PhD thesis"
                   else
                     %i[inproceedings conference].include?(entry.type) || field.call(:kind) == "conference" ? "Conference paper" : "Journal article"
                   end
      doi = field.call(:doi).sub(/\A(?:https?:\/\/(?:dx\.)?doi\.org\/|doi:\s*)/i, "")
      arxiv = field.call(:arxiv)
      arxiv = field.call(:eprint) if arxiv.empty? && field.call(:archiveprefix).casecmp("arxiv").zero?
      arxiv = arxiv.sub(/\A(?:https?:\/\/arxiv\.org\/(?:abs|pdf)\/|arxiv:\s*)/i, "").sub(/\.pdf\z/, "").sub(/v\d+\z/, "")
      authors = Array(csl["author"]).map do |author|
        family = author["family"].to_s
        name = author["literal"] || [author["given"], author["non-dropping-particle"], family, author["suffix"]].compact.reject(&:empty?).join(" ")
        ris_name = author["literal"] || [[author["non-dropping-particle"], family].compact.reject(&:empty?).join(" "), author["given"], author["suffix"]].compact.reject(&:empty?).join(", ")
        { "name" => name, "ris_name" => ris_name, "self" => family.gsub(/[*†‡§¶‖]/, "").casecmp("Malavazi").zero? }
      end
      date_parts = csl.dig("issued", "date-parts", 0) || []
      venue = [field.call(:journal), field.call(:booktitle), field.call(:school), field.call(:institution)].find { |value| !value.empty? }.to_s
      venue = "arXiv" if kind == "preprint"
      url = field.call(:url)
      url = "https://doi.org/#{doi}" if url.empty? && !doi.empty?
      url = "https://arxiv.org/abs/#{arxiv}" if url.empty? && !arxiv.empty?
      item = {
        "key" => entry.key,
        "id" => id,
        "title" => field.call(:title),
        "authors" => authors,
        "authors_text" => authors.map { |author| author["name"] }.join(", "),
        "year" => field.call(:year),
        "month" => date_parts.fetch(1, 0).to_i,
        "day" => date_parts.fetch(2, 0).to_i,
        "kind" => kind,
        "type_label" => type_label,
        "venue" => venue,
        "volume" => field.call(:volume),
        "number" => field.call(:number).empty? ? field.call(:issue) : field.call(:number),
        "pages" => field.call(:pages),
        "doi" => doi,
        "url" => url,
        "pdf" => field.call(:pdf),
        "arxiv" => arxiv,
        "code" => field.call(:code),
        "data" => field.call(:data),
        "summary" => field.call(:summary),
        "featured" => field.call(:featured).casecmp("true").zero?,
        "bib_url" => "/assets/bibliography/#{id}.bib",
        "ris_url" => "/assets/bibliography/#{id}.ris",
        "permalink" => "/publications/##{id}"
      }
      item["bibtex"] = clean_bibtex(entry, item)
      item["ris"] = ris(item)
      item["citation"] = citation(item)
      item["schema_json"] = JSON.generate(schema(item)).gsub("<", "\\u003c").gsub("&", "\\u0026")
      item
    end

    def clean_bibtex(entry, item)
      fields = STANDARD_FIELDS.each_with_object({}) do |key, result|
        value = entry[key]&.to_s&.strip.to_s
        result[key] = value unless value.empty?
      end
      # BibTeX uses 'number' for an issue; 'issue' is common in publisher exports.
      fields[:number] = item["number"] unless item["number"].empty?
      fields[:pages] = fields[:pages].gsub(/[–—]/, "--") if fields[:pages]
      fields[:doi] = item["doi"] unless item["doi"].empty?
      fields[:url] = item["url"] unless item["url"].empty?
      unless item["arxiv"].empty?
        fields[:eprint] = item["arxiv"]
        fields[:archiveprefix] = "arXiv"
      end
      BibTeX::Entry.new(fields.merge(bibtex_type: entry.type, bibtex_key: entry.key)).to_s
    end

    def citation(item)
      parts = ["#{item['authors_text']} (#{item['year']}).", item["title"]]
      details = item["venue"].dup
      details << " #{item['volume']}" unless item["volume"].empty?
      details << "(#{item['number']})" unless item["number"].empty?
      details << ", #{item['pages']}" unless item["pages"].empty? || item["pages"] == "--"
      parts << details unless details.empty?
      parts << (item["doi"].empty? ? item["url"] : "https://doi.org/#{item['doi']}")
      parts.reject(&:empty?).map { |part| part.match?(/[.!?]\z/) || part.start_with?("http") ? part : "#{part}." }.join(" ")
    end

    def ris(item)
      type = if item["kind"] == "thesis"
               "THES"
             elsif item["kind"] == "abstract"
               "ABST"
             elsif item["kind"] == "preprint"
               "UNPB"
             elsif item["type_label"] == "Conference paper"
               "CPAPER"
             else
               "JOUR"
             end
      lines = ["TY  - #{type}", "ID  - #{item['key']}", "TI  - #{item['title']}"]
      item["authors"].each { |author| lines << "AU  - #{author['ris_name']}" }
      lines << "PY  - #{item['year']}"
      venue_tag = item["kind"] == "thesis" ? "PB" : (type == "JOUR" ? "JO" : "T2")
      { venue_tag => "venue", "VL" => "volume", "IS" => "number", "DO" => "doi", "UR" => "url" }.each do |tag, field|
        lines << "#{tag}  - #{item[field]}" unless item[field].empty?
      end
      unless item["pages"].empty? || item["pages"] == "--"
        first, last = item["pages"].split(/--|–/, 2)
        lines << "SP  - #{first}"
        lines << "EP  - #{last}" if last
      end
      lines << "M3  - #{item['type_label']}"
      lines << "ER  -"
      lines.join("\r\n") + "\r\n"
    end

    def schema(item)
      result = {
        "@context" => "https://schema.org",
        "@type" => item["kind"] == "thesis" ? "Thesis" : "ScholarlyArticle",
        "name" => item["title"],
        "author" => item["authors"].map { |author| { "@type" => "Person", "name" => author["name"] } },
        "datePublished" => item["year"],
        "url" => item["url"]
      }
      result["identifier"] = "https://doi.org/#{item['doi']}" unless item["doi"].empty?
      result["isPartOf"] = { "@type" => "Periodical", "name" => item["venue"] } if item["kind"] == "article" && !item["venue"].empty?
      result["pagination"] = item["pages"] unless item["pages"].empty? || item["pages"] == "--"
      result["volumeNumber"] = item["volume"] unless item["volume"].empty?
      result["issueNumber"] = item["number"] unless item["number"].empty?
      result
    end

    def download(site, filename, content)
      site.static_files << PublicationDownload.new(site, filename, content)
    end
  end
end
