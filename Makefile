.PHONY: build run test vet crossbuild fmt sbom clean hooks vulncheck docs

BIN := app
SBOM_FILE := sbom.cdx.json
CYCLONEDX_GOMOD := github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@v1.12.0
GOVULNCHECK := golang.org/x/vuln/cmd/govulncheck@v1.8.0

build: hooks ## compile ./bin/$(BIN)
	go build -o bin/$(BIN) .

run: hooks  ## go run main.go
	go run .

test: hooks ## run tests
	go test -cover ./...

vet:        ## static checks
	go vet ./...

crossbuild: ## compile all supported release platforms
	GOOS=linux GOARCH=amd64 go build ./...
	GOOS=windows GOARCH=amd64 go build ./...
	GOOS=darwin GOARCH=amd64 go build ./...
	GOOS=darwin GOARCH=arm64 go build ./...

fmt:        ## gofmt all files
	gofmt -l -w .

sbom:       ## generate CycloneDX SBOM (sbom.cdx.json)
	go run $(CYCLONEDX_GOMOD) mod -json -licenses -output $(SBOM_FILE) .

vulncheck:  ## scan deps and Go stdlib for known vulnerabilities
	go run $(GOVULNCHECK) -show verbose ./...

clean:      ## remove build artifacts
	rm -rf bin
	rm -f $(SBOM_FILE)

hooks:      ## install versioned git hooks (gofmt on pre-commit)
	git config core.hooksPath .githooks

docs:       ## serve the docs site locally with livereload
	cd docs && bundle install && bundle exec jekyll serve --livereload
