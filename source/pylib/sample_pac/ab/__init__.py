'''
sample_pac/ab/__init__py
ab 패키지를 import 할 때 자동 실행
from saple_pac.ab import * 을 수행시 a 모듈만 자동 import되도록 하기 위해
__all__를 셋팅
'''
__all__=['a']
print('sample_pac.ab 패키지 로드')