# HTTP

HTTP는 흔히 인터넷 주소 앞에 붙어있어 많이 볼 수 있다. 이는 Hyper Text Transfer Protocol의 약자로, 인터넷에서 데이터를 주고받는 프로토콜 규약이다.

HTTP는 메시지를 주고(Request) 받는 (Response) 형태의 통신 방법이다.

클라이언트는 서버에 요청 메시지를 작성하고 서버가 요청 메시지에 대해 답해준다.  따라서 아래 특징을 가진다.

- 단방향 통신
- 서버가 클라이언트에게 먼저 정보를 주지 못함
- 서버의 새로운 정보를 받기 위해 클라이언트가 서버에 재요청을 해서 데이터를 갱신 받아야 한다.
- 따라서 클라이언트에서는 서버 응답이 얼마간 없을 경우 어떻게 반응할 것인지 결정해 두어야 한다.

## Connectionless

또 HTTP는 비연결성으로, 모든 클라이언트의 요청에 대해 항상 새롭게 연결하고 해제하는 과정

## Stateless

무상태로 서버가 클라이언트의 정보를 기억하고 있지 않아서, 클라이언트를 식별할 수 없다. 웹에서는 쿠키, 세션을 통해서 클라이언트를 식별한다. 앱에서는 토큰을 사용하여 클라이언트를 식별한다.

## HTTP Method
HTTP가 통신할 때의 방법으로 해당 방법으로 자료를 가져올 것인지, 저장할 것인지 등을 결정한다.
- GET : 서버에 정보를 요청한다. 
  - URL에 데이터를 포함하여 요청
  - 파라미터를 주소에 포함하여 전달하기 때문에 주소 자체로 인해 보안상 문제가 발생할 수 있다.
  - 따라서 Key값과 같은 중요 데이터는 주소에 직접 노출시키지 않고 헤더에 포함시켜 보낸다.
  - 이론적인 길이 제한은 없지만 대부분의 브라우저에서는 최대 길이를 두고있다.
- POST : 데이터를 보낼 때 사용한다.
  - 데이터를 Body에 포함하여 보낸다. 따라서 주소상으로는 어떤 데이터를 포함하고 있는지 알 수 없다.
  - 주소 자체는 노출되지 않기 때문에 주소만으로 데이터가 노출될 일은 없지만, 그렇다고 보안이 뛰어나다건나 하지는 않다. 바디의 내용 또한 충분히 볼 수 있기 때문
  - 이론적으로 전송 데이터 길이제한이 없다.


|구분|의미|CRUD|멱등성|안정성|PathVariable|Query Parameter|DataBody|
|:-:|:-:|:--:|:--:|:--:|:----------:|:-------------:|:------:|
|GET |리소스 취득     |R|O|O|O|O|X|
|POST|리소스 생성, 추가|C|X|X|O|Δ|O|
|PUT|리소스 생성, 갱신|C/U|O|X|O|Δ|O|
|DELETE|리소스 삭제|D|O|X|O|O|X|
|HEAD|헤더 데이터 취득|·|O|O|·|·|·|
|TRACE|요청메시지 반환|·|O|·|·|·|·|
|CONNECT|프록시 동작의 터널 접속으로 변경|·|X|·|·|·|·|

* 멱등성은 같은 요청에 대한 같은 응답을 한다는 뜻

## 상태 코드(Status Code)
- 통신 시 성공/실패 등 오류를 표기하는 코드
- 보편적인 상태코드가 존재하면서 서버마다 디테일은 상태 코드를 별도로 작성해두고 있기도 하다.

코드는 첫번째 숫자로 상태 특성을 나타내며 두,세번째 숫자로 세부적인 구분을 나타낸다.
- 1xx(정보) : 요청을 받았으며 프로세스를 계속한다
- 2xx(성공) : 요청을 성공적으로 받았고 인식하여 수용함
- 3xx(리다이렉션) : 요청 완료를 위해 추가 작업 조치가 필요
- 4xx(클라이언트 오류) : 요청 문법이 잘못되었거나 요청을 처리할 수 있다.
- 5xx(서버 오류) : 서버가 명백히 유효한 요청에 대해 충족을 실패했다.

[전체 상태코드에 대한 상세 설명(모질라)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

## HTTP 메시지
- 요청 메시지와 응답 메시지로 나뉜다.
- 라인 - 헤더 - 바디 구조로 이루어져 있다.
  - 가장 기본적인 응답/요청 여부, 메시지 전송 방식, 상태 정보 등이 작성
  - HTTP Header : 메시지 본문에 대한 메타 정보
  - HTTP Body: 실제로 보내고자 하는 본문 내용

실제 네이버 API에서 받응 응답
```
* Preparing request to https://openapi.naver.com/v1/search/movie.json?query=%EC%9D%B4%ED%84%B0%EB%84%90%EC%8A%A4&start=1
* Current time is 2021-10-26T01:15:44.633Z
* Using libcurl/7.73.0 OpenSSL/1.1.1k zlib/1.2.11 brotli/1.0.9 zstd/1.4.9 libidn2/2.1.1 libssh2/1.9.0 nghttp2/1.42.0
* Using default HTTP version
* Disable timeout
* Enable automatic URL encoding
* Enable SSL validation
* Enable cookie sending with jar of 1 cookie
* Found bundle for host openapi.naver.com: 0x7ff178a96b30 [can multiplex]
* Re-using existing connection! (#1) with host openapi.naver.com
* Connected to openapi.naver.com (110.93.147.11) port 443 (#1)
* Using Stream ID: 5 (easy handle 0x7ff1992b4e00)

> GET /v1/search/movie.json?query=%EC%9D%B4%ED%84%B0%EB%84%90%EC%8A%A4&start=1 HTTP/2
> Host: openapi.naver.com
> user-agent: insomnia/2021.5.3
> x-naver-client-id: <APIKEY>
> x-naver-client-secret: <APIKEY>
> accept: */*

< HTTP/2 200 
< server: nginx
< date: Tue, 26 Oct 2021 01:15:44 GMT
< content-type: application/json; charset=UTF-8
< content-length: 878
< vary: Accept-Encoding
< apigw-uuid: 706672c2-9a8c-4a85-b33a-6d7f74db8acb
< x-rate-limit: 10
< x-rate-limit-remaining: 9
< x-rate-limit-reset: 1635210945000
< vary: Accept-Encoding
< vary: Accept-Encoding
< x-powered-by: Naver
< vary: Accept-Encoding


* Received 878 B chunk
* Connection #1 to host openapi.naver.com left intact
```

# HTTP vs Socket
## 1. 소켓통신의 특징
- 소켓 또한 서버와 클라이언트 간의 통신 방법의 일종이지만 HTTP와는 달리 양방향 통신이다.
- 양방향 통신이기 때문에 서버측에서 클라이언트에게 먼저 메시지를 보낼 수 있다.
- 지속적인 커넥션을 유지하고 있는 부분이 또 차이가 있다. 따라서 Socket은 자원 점유율이 높다.

## 2. HTTP 통신의 특징
- 단방향 통신으로 클라이언트 요청시에만 서버가 응답한다.
- 필요한 경우에만 통신이 되기 때문에 소켓과 비교해 비교적 자원 점유율이 낮다
- 클라이언트에서 새로운 데이터, 혹은 업데이트가 필요할 경우 반드시 서버에게 재요청을 하게된다.

## 3. HTTPS
- HTTPS는 HTTP뒤에 S(secure)를 추가한 규약으로 TCP와 HTTP(전송 계층와 응용 계층)사이에서 작용하여, 데이터를 암호화 하여 전송한다.
- URL자체는 확인하는 용도로 쓰기 때문에 URL노출을 보호해주지는 않는다.
- 그 외 쿼리스트링, 파라미터 등은 암호화 하여 전송된다.
- https와 달리 http통신의 경우 네트워크 패킷 프로그램을 통해서 통신 과정의 값을 확인하거나 위변조 할 수 있다.