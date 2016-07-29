# PersonalBlog
Contains sources of my personal blog  http://lukaszmakesstuff.com


## Usage
```sh
git clone https://github.com/igbt6/PersonalBlog.git
```
```sh
pip install virtualenv
```

```sh
cd ~/PersonalBlog
virtualenv env
```
Activate the new created environment
```sh
source env/bin/activate
```

Install Pelican with Markdown if you like
```sh
pip install pelican
pip install Markdown
```

Bulid the blog content
```sh
pelican content
```

Check if all works correctly
```sh
cd ~/PersonalBlog/output
python -m pelican.server
```

Fire up a web browser and jump to ''http://localhost:8000/''



In case of any questions feel free to ask!


