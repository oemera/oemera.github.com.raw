dailyOemer Blog Raw Jekyll Files
================================

This is the source for my personal blog called [dailyOemer.com](http://dailyoemer.com). 

Usage
-----
	
	sudo easy_install Pygments
    bundle install
    ejekyll

Build & Deploy to Github
------------------------

For a automatic build and deploy process I use couple of bash commands. I got the idea from [Charlie Park's Jekyll + Plugins + Github + You article](http://charliepark.org/jekyll-with-plugins/)

	alias build_blog="\
	cd ~/workspace/oemera.github.com.raw; \
	rm -r _site; rm -r _clicky_cache; ejekyll; \
	cd ~/workspace/oemera.github.com; \
	rm -rf $(ls -la | grep -v .git | grep -v . | grep -v .. | grep -v .nojekyll | grep -v README.md); \
	cp -r ~/workspace/oemera.github.com.raw/_site/* \
	~/workspace/oemera.github.com; \
	cd ~/workspace/oemera.github.com;\
	git add .;git commit -am 'Latest build.';git push"
	
	alias bb="build_blog"