apply = puppet apply --noop --modulepath=.. --verbose --debug
parse = puppet parser validate
lint = puppet-lint --no-80chars-check --with-filename

test:
	find tests/ manifests/ -name \*.pp | xargs -n 1 $(apply)

parse:
	find tests/ manifests/ -name \*.pp | xargs -n 1 $(parse)

lint:
	find tests/ manifests/ -name \*.pp | xargs -n 1 $(lint)