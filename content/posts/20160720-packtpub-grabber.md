Title: PacktPublishing eBook grabber
Date: 2016-07-20 21:56
Category: Web, Python

Hello reader!

Today, I am going to show you how to create a simple python script which will automatize your job with claiming daily free ebook offered by Packt Publishing. 



### <font color=#669900>*What is it for?*</font>
[Packt Publishing](https://www.packtpub.com) offers its customers a free ebook everyday. 
To claim the book, first you have to create a personal packtpub account [here](https://www.packtpub.com/register). After this you can claim everyday a new IT technical ebook from [here](https://www.packtpub.com/packt/offers/free-learning). It requires to repeat many manual steps in order to claim and then download an ebook. Of course it takes time and it will probably cause you miss a valuable position finally. That's why i created a simple 2 scripts, that automatically claim and download a daily free eBook in chosen format/s.



### <font color=#669900>*Sources*</font>

Full source code of the scripts you can find on my [github profile](https://github.com/igbt6/Packt-Publishing-Free-Learning). You can find there also full setup steps that are required to make scripts work.
Project sonsits of 3 main files:

* *grabPacktFreeBook.py*
* *packtFreeBookDownloader.py*
* *configFile.cfg*
 
Script ``grabPacktFreeBook.py`` is responsible for logging onto your account and claiming the daily ebook (adding it to [your ebooks list](https://www.packtpub.com/account/my-ebooks).
First step is to read all configuration parameters from *configFile.cfg* such as your account email and password 
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
To observe a network traffic during login attempt, go to [https://www.packtpub.com/](https://www.packtpub.com/) and click on login button located at right corner of the website. You should see a prompt window like shown below:
<img src="/static/20160720-packtpub-free-ebook-grabber/20160720-packtpub-free-ebook-grabber-login-prompt.png" width="100%">
Now it's time to open network traffic debugger in your webbrowser, in Firefox press the F12 key as i mentioned before. Click *Network* label and you can choose *All* types of sources to be sniffed. Clean console before by clicking on *bin icon*. Type down your correct login data into login prompt fields and send all to the server by pressing the login button. When all went correctly what means you are correctly logged into your account, choose first POST method from console logs, and now you are to extarct some useful information that will let you build correct POST request to be used in our script.

!!! paste here 2 photos!
As you probably noticed we have got all the informations we need to add to our POST request to make it valid.    

TO BE DONE soon! 

   
