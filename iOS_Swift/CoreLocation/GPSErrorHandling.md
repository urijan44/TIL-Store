# Core Location GPS Error Handling


>참고서적 : Raywenderlich UIKit Apperntice

>Code License : Raywenderlich

모바일 디바이스에서 GPS 좌표를 가져오는 해우이에는 오류가 발생하기 쉽다. 건물 내부, 고층 건물이 많은 지역, 시야가 차단된 곳 등에서 GPS 신호는 차단될 여지가 있다.

주변에 Wi-Fi 라우터가 많지 않거나 있어도 일부 정보를 제공하지 않는 라우터도 많기 때문에 GPS 좌표를 얻는 것에 마이너스 요소가 된다.

마찬가지로 신호 강도에 따라 셀룰러 또한 삼각측량 법이 좋은 결과를 얻지 못할 수 있다.

심지어 위의 모든 가정은 디바이스에 GPS 또는 셀룰러 장치가 있다고 가정했을 때 이다. iPad, iPod Touch 등은 GPS 좌표를 가져올 수 없다.

아무튼 GPS 좌표는 항상 정확하지 못한 데이터를 전송하거나 에러가 날 수 있기 때문에 이에대한 대처를 분명히 하는 것이 좋다.

CoreLocation의 `locationManager(_:didFailWithError:)`을 통해 에러를 판단할 수 있다.

```Swift
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if (error as NSError).code == CLError.locationUnknown.rawValue { 
        return 
    }
    lastLocationError = error
    stopLocationManager()
    ...
}
```
<hr>

[Developer Apple CLError Document](https://developer.apple.com/documentation/corelocation/clerror)

- `CLError.locationUnknown` - 위치는 모르지만 Core Location은 계속 동작중
- `CLError.denied` - 사용자가 위치 서비스 이용 권한을 거부한 경우
- `CLError.network` - 네트워크 관련 오류
<hr>

```Swift
if (error as NSError).code == CLError.locationUnknown.rawValue {
  return
}
```
오류가 `locationUnknown`일 때 심각한 에러는 아니므로 `locationManager(_:didFailWithError:)`를 중지하지만 더 심각한 오류가 발생하게 되면
```Swift
lastLocationError = error
stopLocationManager()
```
을 수행하여 새 인스턴스 변수에 에러를 저장 후 위치 업데이트를 중단한다.

## 위치 업데이트 중지
위치 업데이트를 중지하는 것은 매우 중요한데 어플리케이션을 사용하다 보면 과도하게 GPS 신호를 수신하는 경우 휴대폰 배터리가 녹아 내리는 경우를 경험한 사람들이 많을 것이다. 배민 커넥트 하다 보면 진짜 배터리 녹아 내린다.

아무튼 위치 업데이트를 중지하는 것은 굉장히 중요한 과정이다

`stopLocationManager()`
```Swift
let locationManager = CLLocationManager()
...
func stopLocationManager() {
  if updatingLocation {
    locationManager.stopUpdatingLocation()
    locationManager.delegate = nil
    updatingLocation = false
  }
}
```


## GPS 결과 개선
GPS의 경우 가만히 있어도 값이 종종 변하기 때문에 제자리에 있어도 위치 업데이트가 계속 되면서 GPS 탐색이 계속되면 전반적인 경험이 하락할 우려가 있다. 따라서 GPS값이 계속 변하더라고 같은 자리에 있다고 판단되면 GPS 탐색을 중지할 필요가 있다.


```Swift
func locationManager(
  _ manager: CLLocationManager, 
  didUpdateLocations locations: [CLLocation]
) {
  let newLocation = locations.last!

  if newLocation.timestamp.timeIntervalSinceNow < -5 {
    return
  }

  if newLocation.horizontalAccuracy < 0 {
    return
  }

  if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {

    lastLocationError = nil
    location = newLocation

    if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
      stopLocationManager()
    }
    updateLabels()
  }
}
```


```Swift
if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
```
위 코드의 의미는 최근의 위치 정보가 너무 오래된 경우(이 경우 5초) 사용자가 많이 움직이지 않았을 가능성이 크므로 GPS를 업데이트 하지 않고 이전 결과를 제공하는 방법이다.

```Swift
if newLocation.horizontalAccuracy < 0 { return }
```
새로운 위치 결과가 이전 위치 결과보다 더 정확한지 판별하기 위해 `horizontalAccuracy`를 확인하는데 이 경우 0보다 작다는 것은 불가능 하므로 유효하지 않은 결과로 보고 무시한다.


```Swift
if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {

  lastLocationError = nil
  location = newLocation

  if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
      stopLocationManager()
  }
  updateLabels()
}
```
새 위치정보가 이전 위치 정보 보다 정확하다면 새 위치정보로 할당하는데 사전에 설정한 타겟 정확보다 정확하다면 업데이트를 하지 않아도 된다.


