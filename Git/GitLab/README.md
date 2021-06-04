## **목표**

- Github과 Gitlab에 차이를 알아보고, Gitlab에 실행하는 과정을 이해하기

## **학습 내용**
- [Git이란?](#Git이란?)
- [GitLab이란?](#GitLab이란?)
- [GitLab 사용해보기](#GitLab-사용해보기)

# **Git이란?**

- 형상관리 도구

![image](https://user-images.githubusercontent.com/69107255/120749954-6d769980-c540-11eb-9277-d20404c17b57.png)

학교에서 교양수업 과제를 팀플 과제를 하다보면 많은 수정이 발생하게 됩니다.<br>
내용을 추가/수정/삭제하는 과정을 거치면서 `발표자료(최종).doc`본을 만들어나갑니다.<br>
이 경우 이전 완성본이 필요 할 수 있어서 `발표자료(수정).doc`, `발표자로(수정1).doc`등 이전 완성본을 남겨두고 작업을 할 때가 있습니다.<br> 
💣 **이 때 문제점이 발생합니다.**
- 내가 각 파일의 어떤 내용을 수정/추가/삭제를 했는가?
- 어떤 파일에 내가 원하는 내용이 있는가?

위와 같은 문제점이 발생하기 때문에 모든 doc파일을 열어봐야한다는 시간적인 비용이 발생하게 됩니다.

위와 같은 문제점을 방지하기 위해서는 **버전 관리**를 해야합니다.<br>
그 중에 **분산형 버전 관리 시스템(Version Control System)** 의 한 종류인 **Git**에 대해서 알아보겠습니다.<br>

![image](https://user-images.githubusercontent.com/69107255/120752476-bfb9b980-c544-11eb-83c9-ec113e06968a.png)


 `Hello(이름 추가).java`버전 1파일과 `Hello(나이 추가).java` 버전 2파일을 작성 후 최종적으로 `Hello(최종).java` 버전 3을 만들었습니다. 파일에 변화를 시간에 따라서 기록 한 후 나중에 특정 시점에 버전을 다시 불러올 수 있습니다.<br>

 ## **버전 관리의 장점**

- 지난 개발 과정들을 확인 할 수 있고, 해당 버전에 문제가 생길 시 이전 버전으로 돌아갈 수 있다.
- 여러 개발자가 소스코드를 일일히 시간 비용을 들여서 합칠 필요없이 각자의 branch를 통하여 개발 후 main branch에 병합(Merge)하는 개발 방식이 가능하다. 즉, 여러 개발자가 동시에 작성한 코드들을 합칠 수 있다.
- Github과 GitLab은 원격 저장소를 Web을 통해서 제공하는 소프트웨어이다. 코드가 유실이 되더라도 원격지에 저장이 되어있기 때문에 소스코드가 유실되는 것을 방지할 수 있다.

# **GitLab이란?**

- Git 웹 호스팅 시스템

gitHub과 GitLab은 우리가 협업하고 있는 코드를 저장하는 서버이다. 위에 버전 관리 시스템을 지원하는 Git 웹 호스팅 서비스의 기능을 통하여 push,pull,request 명령어로 배포 실행을 할 수 있다.<br>
이름에 Git이라는 단어가 들어가 있는 것처럼 Git이라는 방식에 원격저장소에 역할을 제공하는 것이 GitLab이라는 소프트에 가장 중요한 특징입니다.

# **GitLab 사용해보기**

OS가 mac이기 때문에 터미널 환경에서 진행하는 과정을 연습해보았습니다.

## **1. 회원가입** 

- 1-1. GitLab을 이용하기 위해서 해당 사이트에 접속 후 회원가입을 한다.

## **2. ssh key 생성**

```
ssh-keygen
```

ssh-keygen을 통하여 ssh key를 만듭니다.<br>
ssh-key는 **비공개 키(identification)** 와 **공개키(public key)** 로 나누어져 있습니다.<br>

**비공개 키(identification)** 는 보안에 주의해야 하기 때문에 노출이 되지 않는곳에 보관해야한다.<br>
**공개 키(public key)** 는 접속하고자 하는 서버에 업로드하여 ssh로 접속할 때 사용하는 key이다.<br>
<br>
GitLab이 제공하는 Git원격 저장소에 ssh프로토콜을 사용하여 접근하기 때문에 **공개 키(public key)** 를 등록해준다.

![image](https://user-images.githubusercontent.com/69107255/120761378-15e02a00-c550-11eb-88bc-87b7b6a51a7f.png)

## **3. 공개 키(public key)확인하기** 
```java
cd ~/.ssh // 자기자신의 homedir밑에 있는 .ssh.dir로 이동한다.

ls -al // 모든 파일들을 보면 id_rsa.pub파일이 있다 해당 파일을 GitLab에 등록해주어야한다.

cat id_rsa.pub // 해당 명령어 실행 시 나오는 파일에 내용을 copy한다.
```

## **4. ssh-key 등록하기**

**4-1. Edit Profile을 클릭한다.** 

![image](https://user-images.githubusercontent.com/69107255/120761949-b0d90400-c550-11eb-80fc-883808342e89.png)

**4-2. SSH Keys를 클릭한다.**

![image](https://user-images.githubusercontent.com/69107255/120762184-f5649f80-c550-11eb-89f0-59fd15348b6d.png)


**4-3. 터미널에서 복사한 공개 키(public key)를 부분을 검은색 textarea에 등록(Add key)해준다.**

![image](https://user-images.githubusercontent.com/69107255/120762722-7ae84f80-c551-11eb-874e-69566ae0f2c8.png)

SSH-key 공개 키(public)가 내 GitLab계정에 등록을 했으니 Local-컴퓨터에서 원격저장소에 접근할 수 있는 권한을 얻게 되었습니다.

## **5. Project 만들기**

- **5-1. Projects** 클릭 한다.
- **5-2. Create blank project/repository** 클릭 후 `Project name`과 `Project description (optional)`을 작성한다.

✨Git 설치를 해서 사용해야 합니다.

![image](https://user-images.githubusercontent.com/69107255/120766241-fe577000-c554-11eb-8b2d-404fe08d1ce0.png)

git을 이용해 사용자 이름으로 jang ilkyu로 사용하고 이메일을 입력함으로써 내가 누구인지 GitLab계정이 확인할 수 있도록하고 다른 계정과 식별 할 수 있도록 식별자 역할을 한다.

![image](https://user-images.githubusercontent.com/69107255/120766454-3a8ad080-c555-11eb-84cc-4a53d8ed4043.png)

- Create a new repository
    - 원격 저장소를 생성 후 생성 된 원격 저장소가 출발점으로 프로젝트를 진행할 경우 사용

- Psuh an existing Git repository
    - Git과 관련된 프로젝트를 진행해왔거나 여러번 commit이 이뤄진 상황에서 원격저장소에 동기화 시켜서 원격저장소로 이전 하고 싶은 경우 사용

저는 hello라는 빈 프로젝트로 출발하기 때문에 `Create a new repository`로 진행하겠습니다.

```java
    git clone git@gitlab.com:jang.dev/hello.git // 해당 루트에 대한 레포지토리를 clone을 통해 복제한다.
    cd hello // hello dir로 이동한다.
    touch README.md // README.md 마크다운 파일을 생성한다.
    git add README.md // 저장소에 올리기위해 REAMDE.md를 추가(add)한다. 저장소에 반영은 되지 않는다.
    git commit -m "add README" // commit을 통하여 REAMDE.md 파일에 변경사항을 원격 저장소에 반영하여 기록하기 위해 "add README"라는 이름으로 버전을 하나 만든다.
    git push -u origin main // git push 명령어를 통하여 로컬 저장소에 내용을 원격 저장소로 반영한다. 
    // origin은 gitLab에 주소에 별명이다.
    // master는 branch 이름이다.
```

**5-3. git clone git@gitlab.com:jang.dev/hello.git**

- git clone을 통하여 hello.git 원격 저장소를 복제 해왔다.

![image](https://user-images.githubusercontent.com/69107255/120769883-868b4480-c558-11eb-9206-37200a45e0c3.png)

![image](https://user-images.githubusercontent.com/69107255/120768405-13350300-c557-11eb-8a6c-502361b8f5eb.png)

GitHub에서는 디렉토리를 만들고 git init을 해서 .git파일을 만들었는데 clone을 통해서 원격저장소를 복제 해오는 방식인것 같다.

**5-4. cd hello / touch README.md / git add README.md**

- hello 디렉토리로 이동 후 README.md파일을 생성 후 README.md가 추적 되도록 하였다.

![image](https://user-images.githubusercontent.com/69107255/120770204-dff37380-c558-11eb-89a0-5dc8a6e68d8c.png)


**5-5. git commit -m "add README" / git push -u origin main**

- git commit을 통하여 버전을 만든 후 push명령을 통하여 로컬 저장소에 내용을 원격 저장소에 반영하였다.

![image](https://user-images.githubusercontent.com/69107255/120770524-306ad100-c559-11eb-814a-a19d1e4b0a71.png)


## **결과**

내가 추가한 README.md파일이 원격저장소에 잘 추가 된 것을 확인 할 수 있었다.

![image](https://user-images.githubusercontent.com/69107255/120770813-80e22e80-c559-11eb-9b30-fd797bab6d3d.png)
