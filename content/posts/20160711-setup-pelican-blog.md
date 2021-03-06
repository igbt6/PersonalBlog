Title: How to setup Pelican blog 
Date: 2016-07-11 00:20
Category: Web

Hello Reader!

In my first post I would like to show you how to create, configure and setup a simple static blog site like this mine.

The blog is created using [Pelican](getpelican.com) - a static site generator, written in Python. The utility lets you create weblogs using  [reStructuredText](http://docutils.sourceforge.net/rst.html) or [Markdown](https://daringfireball.net/projects/markdown/) text formats. Pelican's main features are following:

- *Articles* (blog posts, pages like About, Projects, Contact)
- *Comments*
- *Theming support*
- *Publication of articles in multiple languages*
- *Atom/RSS feeds*
- *Code syntax highlighting*
- *Import from WordPress, Dotclear, or RSS feeds*

I am not going to talk here about advantages or disadvantages of static websites over dynamic ones. Main reason for me of using such solution is that you can host it easily anywhere. Later I will show you how to host your blog on github in a few easy steps and what is important completely free of charge :) 



### <font color=#669900>*Install Pelican*</font>

As a first step I highly recommend you to install ``virtualenv`` package on your computer. It creates an isolated *virtual environment* for your program. More speciffically it creates a separate folder that contains copy of the Python binary and *site-packages* directory so it lets you install/update required packages by your application without changing global instance of Python packgage. More details to be found here: [virtualenv site](https://virtualenv.pypa.io/en/stable/).
To install virtualenv just type the following in your command line (don't forget about *sudo*)
```sh
pip install virtualenv
```
Now create a folder that contains your project and create a new virtual environment inside
```sh
cd mkdir -p ~/projects/yourblog
cd ~/projects/yourblog
virtualenv env
```
Activate the new created environment
```sh
source env/bin/activate
```

Now you can check which python version is being used
```sh
which python
```

You should get a response like that:
```sh
/projects/yourblog/env/bin/python
```

It just means that currently used python is that one created in virtual environment

Install Pelican and Markdown packages
```sh
pip install pelican
pip install Markdown
```



### <font color=#669900>*Create your blog*</font>

The fastest way of creating new project is to use a default skeleton-project and then to extend it with your own content

In your project folder run the following commands:
```sh
cd ~/projects/yourblog
pelican-quickstart
```
Now you will be asked to fill up some informations about your site, you can also use default values denoted in brackets. Look on sample setup informations below:
<img src="/static/20160711-setup-pelican-blog/20160711-setup-pelican-blog-create-site.png" width="100%">

Once the skeleton of your blog project has been created, it's time to create your first post
```sh
cd ~/projects/yourblog/content
vim firstpost.md 
```
and paste the following content into *firstpost.md* and save the file:
```
Title: My First Post
Date: 2016-17-11 00:20
Category: Electronics

My first demo post :-)
```

To generate your site type the following command:
```sh
pelican content
```
Your static site has now been generated into the output directory. 



### <font color=#669900>*Preview your blog site*</font>
In order to preview your site in the browser, it's a good way to run an embedded Pelican's server.
```sh
cd ~/projects/yourblog/output
python -m pelican.server
```
Once the basic server has been started, you can preview your site at http://localhost:8000/

That's it, your Pelican webblog is already working. It should look similarly to this:
<img src="/static/20160711-setup-pelican-blog/20160711-setup-pelican-blog-firstview.png" width="100%"> 
For more setup details and information you should visit [official tutorial](http://docs.getpelican.com).



### <font color=#669900>*Changing default theme*</font>
As you probably have already noticed, the theme of my blog is different than the default one. The theme i used for my blog is [pelican-bootstrap3](https://github.com/getpelican/pelican-themes/tree/master/pelican-bootstrap3). Thanks to usage of Bootstrap library, the theme makes your site fully responsive.
To change the theme run the following
```sh
git clone https://github.com/getpelican/pelican-themes.git
```
and point the ``THEME`` variable in your *pelicanconf.py* to */path/to/pelican-bootstrap3*:
<img src="/static/20160711-setup-pelican-blog/20160711-setup-pelican-blog-theme-setup.png" width="100%">  

You can also check other *Pelican* themes from [here](https://github.com/getpelican/pelican-themes) and read more detailed description from official [pelican-themes documentation](http://docs.getpelican.com/en/3.6.3/pelican-themes.html)



### <font color=#669900>*Hosting your blog on GitHub*</font>
I am going to show you how easily and quickly you can host your newly created *Pelican* webblog on github using [GitHub Pages](https://pages.github.com/).
First step to be done is creating Github account if you have not done it yet.
For more details jump [here](https://help.github.com/articles/signing-up-for-a-new-github-account/). 
Once you are done create a new repository named ``yourusername.github.io``, where yourusernameusername is (yes, you guessed correctly :D) your username on GitHub.
Now it's time to clone your newly created repo
```sh
git clone https://github.com/yourusername/yourusername.github.io
```

Copy the content of the generated *output* directory to the cloned repository
```sh
cp -r /projects/yourblog/output* /yourusername.github.io
```
Add, commit, and push your changes:
```sh
git add --all
git commit -m "Initial commit"
git push -u origin master
```
…and you're done!
Fire up a browser and go to *http://yourusername.github.io*


### <font color=#669900>*Summary*</font>
That's all i wanted to share with you in this post. I liked very much the idea of static websites, they are easy to maintain, quick to develop, and cheap to host. *Pelican* is one of many static site generators you can use, but in my opinion it is one of the most advanced and with huge community of developers working on it. If you don't know where to start with making static webpages, *Pelican* will be a great choice for everyone.
Thanks for reaching here and reading the content above. I hope you find it useful.
In case of any questions feel free to ask or comment below;
 
Keep making!

