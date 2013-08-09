module_name = nodejs

apply = puppet apply --noop --modulepath=./modules --verbose --debug
parse = puppet parser validate
lint = puppet-lint --no-80chars-check --with-filename

test:
	find tests/ manifests/ -name \*.pp | xargs -n 1 $(apply)

parse:
	find tests/ manifests/ -name \*.pp | xargs -n 1 $(parse)

lint:
	find tests/ manifests/ -name \*.pp | xargs -n 1 $(lint)

librarian-puppet:
	librarian-puppet install --verbose --clean
	mkdir modules/$(module_name)
	ln -s $(PWD)/modules modules/$(module_name)/modules
	ln -s $(PWD)/files modules/$(module_name)/files
	ln -s $(PWD)/templates modules/$(module_name)/templates
	ln -s $(PWD)/manifests modules/$(module_name)/manifests
	ln -s $(PWD)/lib modules/$(module_name)/lib
