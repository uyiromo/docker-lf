# docker-lf
- Dockerfile for Linter/Formatter

## build
```bash
docker build -t docker-lf .
```

## supported linters/formatters

| language | linter | formatter |
| --- | --- | --- |
| markdown | markdownlint-cli | markdownlint-cli |
| python | flake8 | isort <br> black |
| shell | shellcheck | shfmt |
| toml | taplo | taplo |
| yaml | - | yamlfmt |
| json | - | js-beautify |
| javascript | eslint | eslint |
| Dockerfile | hadolint | - |

## example
```bash
% docker run --rm --user $(id -u):$(id -g) -v .:/mnt:Z docker-lf markdownlint /mnt/README.md
/mnt/README.md:1 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "# docker-lf"]
/mnt/README.md:2 MD032/blanks-around-lists Lists should be surrounded by blank lines [Context: "- Dockerfile for Linter/Format..."]
/mnt/README.md:4 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "## build"]
/mnt/README.md:5 MD031/blanks-around-fences Fenced code blocks should be surrounded by blank lines [Context: "```bash"]
/mnt/README.md:14:27 MD033/no-inline-html Inline HTML [Element: br]
/mnt/README.md:22 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
/mnt/README.md:23 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 3]
```

