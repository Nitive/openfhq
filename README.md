FHQ Design
==========
##Get started
1. Clone repository
2. Remove "_" prefix from all files inside assets/stylus
	``` bash
	cd assets/stylus/
	rename -d _ *
	```

3. Run `npm install`
4. Run `bower install`
5. Run `gulp product`

Done! Your files inside public.

Run `gulp watch` for watching changes and autocompile html, stylus, coffee, etc
