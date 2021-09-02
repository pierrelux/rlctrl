pandoc "$1/notes.md" -o "$1/notes.pdf" --from markdown --to beamer --template eisvogel.latex -M date="`date "+%B %e, %Y"`" --filter pandoc-latex-environment
