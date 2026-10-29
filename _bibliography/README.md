# Maintaining the publication archive

The Publications page and its downloadable citations are generated from these files:

- `papers.bib`: published journal articles and full conference papers.
- `preprints.bib`: works not yet represented by a published version.
- `thesis.bib`: doctoral and master's theses.

The public list covers quantum research and the optical-tweezers/stochastic-thermodynamics papers. Conference abstracts and earlier neural-probe/MEMS work are intentionally omitted.

Add a standard BibTeX entry with a unique, stable key. Keep the publisher's author order and spelling, title, year, volume and article number or page range. Use a bare DOI such as `10.1103/zg87-t4y5`, and include a working `url`. Supply `month` and `day` when verified; these sort works within each year. UTF-8 names are supported.

Optional display fields:

- `kind = {conference}` for a full proceedings paper. Journal articles need no kind field. Use `@phdthesis` for the doctoral thesis.
- `summary`: a brief original description of the contribution.
- `arxiv`: the arXiv identifier, without a URL or version suffix.
- `pdf`, `code`, `data`: verified, publicly accessible URLs.
- `featured = {true}`: a restrained highlight in the archive.
- `metadata_source`: the primary record used to verify the entry; retained in source only.

When a preprint is published, move it to `papers.bib`, update its final metadata, and retain its arXiv link. Do not list the same work twice. Keep the entry key stable where possible so existing links continue to work.

`_plugins/publication_catalog.rb` builds the year groups, search metadata, plain citations, individual BibTeX/RIS files, and the complete bibliography under `/assets/bibliography/`. No generated downloads need to be committed. Website-only fields are excluded from citation exports.

After updating the bibliography, run `bundle exec jekyll build`. Check the rendered title, author list, year and links, and open an individual citation download and the complete bibliography. The deployment workflow also runs when the generator changes.
