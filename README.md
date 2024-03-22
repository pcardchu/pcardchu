# D110 Git Convention

## Commit

- 💠 **feat**: 새로운 기능 추가
- 🛠 **fix**: 버그 수정
- 📜 **docs**: 문서 변경사항
- 🎀 **style**: 코드 포맷 변경, 세미콜론 누락 등 코드의 기능에 영향을 주지 않는 변경사항
- ✨ **refactor**: 코드 리팩토링
- 🍀 **test**: 테스트 코드, 리팩토링 테스트 코드 추가
- 💭 **chore**: 빌드 업무 수정, 패키지 매니저 설정 등의 변경사항

### 제목

- 50자를 넘지 않도록 합니다.
- 명령문 형태로 작성합니다.
- 대문자로 시작합니다.
- 마지막에 마침표(.)를 사용하지 않습니다.
- Jira 이슈 번호를 ()안에 적습니다.(선택적)

### 본문 (선택적)

- 적절히 줄바꿈을 합니다.
- 어떻게보다는 무엇을, 왜 변경했는지를 설명합니다.

### 꼬리말 (선택적)

- Jira 이슈 번호를 적습니다.

**예시**
```
feat: 사용자 로그인 기능 추가 (S10P12D109-4)

로그인 API 연동과 사용자 인증 로직을 구현했습니다. 
사용자는 이메일과 비밀번호를 통해 로그인할 수 있습니다.

Jira 이슈 번호: S10P12D109-4
```

```
fix: 장바구니 항목 삭제 버그 수정 (S10P12D109-3)

장바구니에서 항목을 삭제할 때 발생하는 오류를 수정했습니다. 
항목 삭제 후 장바구니 업데이트 로직이 제대로 동작하지 않는 문제가 있었습니다.

Jira 이슈 번호: S10P12D109-3
```

![image](/uploads/3e8e75b7e8015d4fbc69641957c715ed/image.png)

MergeRequest의 진행 상황에 따라 라벨(대기, 거절, 승인)을 이용합니다.

## Branch

1. **main 브랜치**: 안정적인 버전의 코드가 저장되는 브랜치로, 프로덕션 준비가 완료된 코드만이 master에 병합됩니다. 일반적으로 배포 가능한 상태만을 유지합니다.
2. **develop 브랜치**: 개발을 위한 주요 브랜치로, 기능 개발 브랜치들이 병합되는 곳입니다. 개발의 최신 상태를 반영하며, 다음 릴리즈를 준비하는 코드가 모여 있습니다.
3. **feature 브랜치들**: 새로운 기능 개발이나 버그 수정을 위해 develop 브랜치로부터 분기된 브랜치입니다. 개발이 완료되면 다시 develop 브랜치로 병합됩니다.

### 예시

- main
    - be/dev
        - be/feat/log-in
    - fe/dev
        - fe/feat/main-page

