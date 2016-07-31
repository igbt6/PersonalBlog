Title: PacktPublishing free eBook grabber
Date: 2016-07-20 21:56
Category: Python
 

Hello reader!

Today, I am going to show you how to create a simple python script which will automatize your job with claiming daily free ebook offered by Packt Publishing. 



### <font color=#669900>*What is it for?*</font>
[Packt Publishing](https://www.packtpub.com) offers its customers a free ebook everyday. 
To claim the book, first you have to create a personal packtpub account [here](https://www.packtpub.com/register). After this you can claim everyday a new IT technical ebook from [here](https://www.packtpub.com/packt/offers/free-learning). It requires to repeat many manual steps in order to claim and then download an ebook. Of course it takes time and it will probably cause you miss a valuable position finally. That's why i created a simple 2 scripts, that automatically claim and download a daily free eBook in chosen format/s.



### <font color=#669900>*Login and claiming a book*</font>

Full source code of the scripts you can find on my [github profile](https://github.com/igbt6/Packt-Publishing-Free-Learning). You can find there also full setup steps that are required to make scripts work.
Project sonsits of 3 main files:

* *grabPacktFreeBook.py*
* *packtFreeBookDownloader.py*
* *configFile.cfg*
 
Script ``grabPacktFreeBook.py`` is responsible for logging onto your account and claiming the daily ebook (adding it to [your ebooks list](https://www.packtpub.com/account/my-ebooks).
First step is to read all configuration parameters from *configFile.cfg* such as your account email and password:

```python
    config =configparser.ConfigParser()    
    try:        
        if(not config.read("configFile.cfg")):
            raise configparser.Error('config file not found')       
        email= config.get("LOGIN_DATA",'email')
        password= config.get("LOGIN_DATA",'password')
        downloadBooksAfterClaim= config.get("DOWNLOAD_DATA",'downloadBookAfterClaim')
    except configparser.Error as e:
        print("[ERROR] loginData.cfg file incorrect or doesn't exist! : "+str(e))
```
If variable ``downloadBooksAfterClaim`` contains "YES" string, it enables automatic download of the claimed ebook.
Most interesting part of the sript are HTTP REST requests being sent to *packtpub.com* server. They are:

* POST request - to login into server
* GET - to claim a free daily ebook.

For this purpose I have used an excellent python library [*requests*](http://docs.python-requests.org/en/master/). It is one of the best python libraries that allows you to send HTTP requests in an easy and fancy way, without need for doing many manual and boring job. 
To form up a correct login POST request, we need to take a look on a body of an "original" post request that is sent by packtpub website while logging. The simplest way to check this is a built-in developer tool which you can find in most of modern webrowsers. I have used a firefox one. Just press F12 key and you can sniff all packets being sent to and back by webbrowser.
To observe a network traffic during login attempt, go to [https://www.packtpub.com/](https://www.packtpub.com/) and click on login button located at right corner of the website. You should see a prompt window like this one below:

<figure>
<img src="/static/20160720-packtpub-free-ebook-grabber/20160720-packtpub-free-ebook-grabber-login-prompt.png" width="90%" height="70%">
<figcaption>
<font size="2">Fig.1 login prompt</font>
</figcaption>
</figure>
<p></p>
<p></p>

Now it's time to open network traffic debugger in your webbrowser. In Firefox, press the F12 key as i mentioned before. Click *Network* label and you can choose *All* types of sources to be sniffed. Clean console before by clicking on *bin icon*. Type down your correct login data into login prompt fields and send all to the server by pressing the login button. When all went correctly what means you are correctly logged into your account, choose first POST method from console logs, and now you are to extarct some useful information that will let you build correct POST request to be used in our script.

<figure>
<img src="/static/20160720-packtpub-free-ebook-grabber/20160720-packtpub-free-ebook-grabber-login-headers.png" width="100%" height="90%">
<figcaption>
<font size="2">Fig.2 POST login request - headers data</font>
</figcaption>
</figure>

<p></p>
<p></p>
<p></p>
<p></p>

<figure>
<img src="/static/20160720-packtpub-free-ebook-grabber/20160720-packtpub-free-ebook-grabber-login-params.png" width="100%" height="90%">
<figcaption>
<font size="2">Fig.3 POST login request - parameters data</font>
</figcaption>
</figure>
<p></p>

I bet, a body of HTTP requests is known for you. I you are not familiar with it yet, take a look [here](http://www.tutorialspoint.com/http/http_overview.htm) before further reading.

```python
    freeLearningUrl= "https://www.packtpub.com/packt/offers/free-learning"
    packtpubUrl= 'https://www.packtpub.com'
    reqHeaders= {'Content-Type':'application/x-www-form-urlencoded',
             'Connection':'keep-alive'}
    formData= {'email':email,
                'password':password,
                'op':'Login',
                'form_build_id':'',
		'form_id':'packt_user_login_form'}
```
The above snippet contains two *directory* structures that describes *headers* and *data* fields of the login POST request. In order to retrieve *form_build_id* we have to extract it from html sources of the page under *freeLearningUrl* as shown below:
<figure>
	<img src="/static/20160720-packtpub-free-ebook-grabber/20160720-packtpub-free-ebook-grabber-login_id.png" width="90%" height="80%">
	<figcaption>
		<font size="2" >Fig.4 form_build_id-extracting data from html source</font>
	</figcaption>
</figure>

The small piece of the scricpt below does this job. First we get thhe webpage sources with GET request. Once we have go a full source of the page, there appears another great python library named [*Beautiful Soup*](https://www.crummy.com/software/BeautifulSoup/bs4/doc/). Its main task is to pull data out from HTML and XML files. Analyzing the code you can see how much it makes your job easier. Besides *form_build_id*, i also extracted *bookTitle* and *claimUrl* which will be used later. 

```python
        r = requests.get(freeLearningUrl,timeout=10)
        if(r.status_code is 200):
            html = BeautifulSoup(r.text, 'html.parser')
            loginBuildId= html.find(attrs={'name':'form_build_id'})['id']
            claimUrl= html.find(attrs={'class':'twelve-days-claim'})['href']
            bookTitle= html.find('div',{'class':'dotd-title'}).find('h2').next_element.replace('\t','').replace('\n','').strip(' ')
            if(loginBuildId is None or claimUrl is None or bookTitle is None ):
                print("[ERROR] - cannot get login data" ) 
                sys.exit(1)                
        else: 
	    raise requests.exceptions.RequestException("http GET status codec != 200")
```

We have already gathered all the data to login, claim the book and store it's under given name. Login and claiming the free ebook are being perforemd here:

```python
	rPost = session.post(freeLearningUrl, headers=reqHeaders,data=formData) #login into packtpub account
	r = session.get(packtpubUrl+claimUrl,timeout=10) #claim ebook
```


### <font color=#669900>*Downloading the claimed ebook*</font>
If all has gone well (we got correct HTTP request reponse codes), it's time to download the claimed free ebook on your computer.
Parameters of the download are clearly described in [DOWNLOAD_DATA] field of ``configFile.cfg``.
```txt
[DOWNLOAD_DATA]
downloadFolderPath: C:\Users\me\Desktop\myEbooksFromPackt
downloadBookAfterClaim: YES
downloadFormats: pdf, epub, mobi, code
;downloadBookTitles: Unity 4.x Game AI Programming , Multithreading in C# 5.0 Cookbook
```
The script that makes the job ``packtFreeBookDownloader.py``
When the field *downloadBookAfterClaim* is set to YES value, after claiming a book, the ebook will be automatically downloaded in chosen formats on your machine what you can find in this code snippet:
```python
        if downloadBooksAfterClaim=="YES":
            from packtFreeBookDownloader import MyPacktPublishingBooksDownloader
            downloader = MyPacktPublishingBooksDownloader(session)
            downloader.getDataOfAllMyBooks()
	    downloader.downloadBooks([bookTitle], downloader.downloadFormats) 
```

You can also use the script separately to download all or chosen titles of the ebooks from your account:

* to downlaod all books the field: *downloadBookTitles* shall be commented out like shown above;
* to download chosen titles from your account put them into *downloadBookTitles* separated by commas.

Go through the source code of ``packtFreeBookDownloader.py`` script to see how it's all implemented.

### <font color=#669900>*Usage*</font>
To make the scripts running daily in autoamtic way, the good idea is to setup a task that will do this jobe for us. I'll show a usage of CRON tool on Ubuntu OS and SCHTASKS for Windows wshich seems proper for this type of tasks.
  
 **UBUNTU** (tested on 16.04):
  
  modify access permissions of the script:
  
```sh
  chmod a+x grabPacktFreeBook.py 
```
  
  *CRON* setup (more: https://help.ubuntu.com/community/CronHowto) :
  
```sh
  sudo crontab -e
```
  
  paste (modify all paths correctly according to your setup):
  
```sh
  0 12 * * * cd /home/me/Desktop/PacktScripts/ && /usr/bin/python3 grabPacktFreeBook.py > /home/me/Desktop/PacktScripts/grabPacktFreeBook.log 2>&1
```
  
  and save the crontab file. To verify if CRON fires up the script correctly, run a command:
  
```sh
  sudo grep CRON /var/log/syslog
```
  
 **WINDOWS** (tested on win7):
  
  *schtasks.exe* setup (more info: https://technet.microsoft.com/en-us/library/cc725744.aspx) :
  
  To create the task that will be called at 12:00 everyday, run the following command in *cmd* (modify all paths according to your setup):
  
```sh
  schtasks /create /sc DAILY /tn "grabEbookFromPacktTask" /tr "C:\Users\me\Desktop\GrabPacktFreeBook\grabEbookFromPacktTask.bat" /st 12:00
```
  
  To check if the "grabEbookFromPacktTask" has been added to all scheduled tasks on your computer:
  
```sh
  schtasks /query
```
  
  To run the task manually:
  
```sh
  schtasks /run /tn "grabEbookFromPacktTask"
``` 
  
  To delete the task:
  
```sh
  schtasks /delete /tn "grabEbookFromPacktTask"
```

### <font color=#669900>*Requirements*</font>
To use the scripts I have to mention about requirements yet.

Before using You need to have already installed either Python 2.x or 3.x on your machine. Install *pip* (if you have not installed it yet).
To do that download:  [https://bootstrap.pypa.io/get-pip.py](https://bootstrap.pypa.io/get-pip.py), then run the following command:

```sh  
  python get-pip.py
```
  
  Once pip has been installed, run the following:
  
```sh
  pip install requests
  pip install beautifulsoup4
```
  
  If you use Python 2.x :
  
```sh  
pip install future
```
Finally change your login credentials in ``configFile.cfg`` file. That's all!    


### <font color=#669900>*Summary*</font>  
In this post i wanted show you how easily you can automatize your job using python language. I hope that materials and code provided here motivate you to build scripts, scrappers, web bots or any other programs that will help you to save some time : ) Feel free to comment or ask any questions below!

Łukasz  
