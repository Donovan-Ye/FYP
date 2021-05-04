# ZhengjieYe's Final Year Project

ZhengjieYe's Final Year Project in WIT in 2021.

## Project structure

The project source code is mainly divided into three parts.
+ [FYP](https://github.com/ZhengjieYe/FYP)
+ [FYP_REACT](https://github.com/ZhengjieYe/FYP_REACT)
+ [FYP_API](https://github.com/ZhengjieYe/FYP_API)

#### FYP -- Key part
This project is designed as a mobile application. This part of the project is developed using Flutter and Dart. Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.
#### FYP_REACT -- React part
Because the Flutter project can embed the Webview into the page, and the webview can be used to display the Web page, the project uses React. Some pages of the project show React pages. Mainly for search and application service pages, as well as application tracking pages.
#### FYP_API -- Back-end part
This part is the back-end project of the project. It uses a combination of Nodejs, Express and GraphQL. Provide APIs for mobile app(FYP) and React pages(FYP_REACT).

## Structure diagram
[technology]: ./assets/readme/technology.png
[architecture]: ./assets/readme/architecture.png


#### Technology structure
<!-- ![][technology] -->

#### System architecture
<!-- ![][architecture] -->


## Setup requirements
**Please note that you need to start FYP_API first, then FYP_REACT, and finally FYP.**
### FYP_API
+ npm install

+ create a enviroment file in the root.

    .env

[api_env]: ./assets/readme/api_env.jpg

> you need to add following variables in this file:
![][api_env]
>+ The first variable is the address of the MongoDB. Please create a MongoDB for yourself.
> + The last four variables are the setting of the AWS S3 bucket. Please create a bucket for yourself, and then get access Key ID and secret access Key(https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html).

+ npm start

### FYP_REACT
+ npm install

+ create a enviroment file in the root.

    .env

[react_env]: ./assets/readme/react_env.jpg

> you need to add following variables in this file:
![][react_env]
>The variable is the address of the API server. Please note that, if you start the API project locally, please replace Localhost with the LAN IP. For example: http://192.168.0.150:4000. Because whether you are using an emulator or a real machine, you cannot access localhost.

+ npm start

### FYP
+ intall Flutter. You can follow the tutorial(https://flutter.dev/docs/get-started/install) from the offical site to install Flutter.

> Here is my Flutter and Dart version

[flutter_version]: ./assets/readme/flutter_version.jpg
> ![][flutter_version]
+ git 

+ create a enviroment file in the root.

    .env

[flutter_env]: ./assets/readme/flutter_env.jpg

> you need to add following variables in this file:
![][flutter_env]
The variable is the address of the API server. Same as FYP_REACT above.


+ Pico voice setting up
Because the project is designed to use a Voice AI to implement the feature of voice recognition. If you want to test the project, please follow the tutorial(https://medium.com/picovoice/offline-speech-recognition-in-flutter-no-siri-no-google-and-no-its-not-speech-to-text-c960180e9239) to create a enterprise account, you will have 30 days trial to use it freely. 
 
+ run the project


## Features overview

1. register

[register-1]: ./assets/readme/register-1.jpg
[register-2]: ./assets/readme/register-2.jpg
[register-3]: ./assets/readme/register-3.jpg
[register-4]: ./assets/readme/register-4.jpg
[register-5]: ./assets/readme/register-5.jpg
+ user type selection 
<br>

![][register-1]
<br>

+ gender selection 
<br>

![][register-2]
<br>

+ username, password, email and phone number
<br>

![][register-3]
![][register-4]
<br>

+ verification code
<br>

![][register-5]

<br>

2. log in

[login]: ./assets/readme/login.jpg
[main-1]: ./assets/readme/main-1.jpg
[main-2]: ./assets/readme/main-2.jpg
+ log in page
<br>

![][login]
<br>

+ main page after log in successfully
<br>

![][main-1]
![][main-2]

<br>

3. voice recognition

[voice-1]: ./assets/readme/voice-1.jpg
[voice-2]: ./assets/readme/voice-2.jpg
[voice-3]: ./assets/readme/voice-3.jpg
[voice-4]: ./assets/readme/voice-4.jpg
[voice-5]: ./assets/readme/voice-5.jpg
[voice-6]: ./assets/readme/voice-6.jpg
[voice-7]: ./assets/readme/voice-7.jpg
[voice-8]: ./assets/readme/voice-8.jpg
[voice-9]: ./assets/readme/voice-9.jpg
[voice-10]: ./assets/readme/voice-10.jpg
+ voice recognition tips when log in first time
<br>

![][voice-1]
![][voice-2]
![][voice-3]
![][voice-4]
![][voice-5]
<br>

+ voice recognition settting
<br>

![][voice-7]
![][voice-8]
![][voice-9]
![][voice-10]
<br>

+ integrate with Flutter app
<br>

![][voice-6]
<br>

4. alarm

[alarm-1]: ./assets/readme/alarm-1.jpg
[alarm-2]: ./assets/readme/alarm-2.jpg
[alarm-3]: ./assets/readme/alarm-3.jpg
[alarm-4]: ./assets/readme/alarm-4.jpg
[alarm-5]: ./assets/readme/alarm-5.jpg
[alarm-6]: ./assets/readme/alarm-6.jpg
[alarm-7]: ./assets/readme/alarm-7.jpg
[alarm-8]: ./assets/readme/alarm-8.jpg
[alarm-9]: ./assets/readme/alarm-9.jpg
+ add new friend to send message
<br>

![][alarm-5]
![][alarm-6]
![][alarm-7]
![][alarm-8]
<br>

+ replace emergency contact
<br>

![][alarm-9]
<br>

+ send message
<br>

![][alarm-1]
![][alarm-2]
<br>

+ make huge sounds and recording video
<br>


![][alarm-3]
<br>

+ uploading video 
<br>

![][alarm-4]
<br>

5. video list
<br>

[list-1]: ./assets/readme/list-1.jpg
[list-2]: ./assets/readme/list-2.jpg

![][list-1]
![][list-2]
<br>

6. fake call

[fake-1]: ./assets/readme/fake-1.jpg
[fake-2]: ./assets/readme/fake-2.jpg
[fake-3]: ./assets/readme/fake-3.jpg
[fake-4]: ./assets/readme/fake-4.jpg
+ setting countdown for fake call if you want
<br>


![][fake-1]
![][fake-2]
<br>

+ fake call with sounds
<br>


![][fake-3]
![][fake-4]
<br>

7. path monitoring

[path-1]: ./assets/readme/path-1.jpg
[monitor-1]: ./assets/readme/monitor-1.jpg
[monitor-2]: ./assets/readme/monitor-2.jpg
+ First, the sharing user needs to click this button to turn on the path monitoring. 
<br>

![][path-1]
<br>

+ then you can see the path after you change the position
<br>

![][monitor-1]
![][monitor-2]
<br>

8. path sharing

[sharing-1]: ./assets/readme/sharing-1.jpg
[sharing-2]: ./assets/readme/sharing-2.jpg
[sharing-3]: ./assets/readme/sharing-3.jpg
[sharing-4]: ./assets/readme/sharing-4.jpg
+ If you want to share your path with other users, you just need to enter the username, for example "jerry"
<br>

![][sharing-1]
<br>

9. accept friends path sharing

+ If you want to share your path with other users, you just need to enter the username, for example "jerry"
<br>

![][sharing-2]
<br>

+ Then you will receive the path sharing
<br>

![][sharing-3]
<br>

+ path sharing page 
<br>

![][sharing-4]

10. provide services
<br>

[provide-1]: ./assets/readme/provide-1.jpg
[provide-2]: ./assets/readme/provide-2.jpg
[provide-3]: ./assets/readme/provide-3.jpg
[provide-4]: ./assets/readme/provide-4.jpg
[provide-5]: ./assets/readme/provide-5.jpg

![][provide-1]
![][provide-2]
![][provide-3]
![][provide-4]
![][provide-5]
<br>

11. apply services
<br>

[apply-1]: ./assets/readme/apply-1.jpg
[apply-2]: ./assets/readme/apply-2.jpg
[apply-3]: ./assets/readme/apply-3.jpg

![][apply-1]
![][apply-2]
12. application tracking
<br>

![][apply-3]
<br>

13. process application

[process-1]: ./assets/readme/process-1.jpg
[process-2]: ./assets/readme/process-2.jpg
[process-3]: ./assets/readme/process-3.jpg
[process-4]: ./assets/readme/process-4.jpg
[process-5]: ./assets/readme/process-5.jpg
[process-6]: ./assets/readme/process-6.jpg
[process-7]: ./assets/readme/process-7.jpg
+ If you want to process the service applied above, you need to log in the provider account.
<br>

![][process-1]
+ Then process the application
<br>

![][process-2]
![][process-3]
![][process-4]
![][process-5]
![][process-6]
<br>

+ Back to original account, see the result of processing
<br>

![][process-7]
<br>

14. check and change personal information
<br>

[my]: ./assets/readme/my.jpg
![][my]

<br>

15. log out
<br>

[logout]: ./assets/readme/logout.jpg
![][logout]