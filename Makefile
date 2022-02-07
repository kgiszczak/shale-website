default:
	@opal -c --no-source-map -I shale/lib -I stubs app.rb > app.js
