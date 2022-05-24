.PHONY: init-aws
init-aws:
	aws cloudformation deploy --template-file website.cfn.yaml --stack-name shalerb-website

.PHONY: deploy
deploy: build
	aws s3 cp dist s3://www.shalerb.org --recursive
	aws cloudfront create-invalidation --distribution-id E1ZYY0483EHU3 --paths "/index.html" > /dev/null

.PHONY: build
build: runtime
	rm -rf dist
	webpack build --mode production

.PHONY: runtime
runtime: clone-opal-uri clone-shale bundle
	cd src/runtime && opal -c --no-source-map -I shale/lib -I opal-uri/opal -I vendor -I stubs runtime.rb > ../website/runtime.js

.PHONY: clone-opal-uri
clone-opal-uri:
	cd src/runtime && (git -C opal-uri pull || git clone https://github.com/ajjahn/opal-uri.git opal-uri)

.PHONY: clone-shale
clone-shale:
	cd src/runtime && (git -C shale pull || git clone https://github.com/kgiszczak/shale.git shale)

.PHONY: bundle
bundle:
	cd src/runtime && bundle
