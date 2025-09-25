# python sample_pac.cd.c.py
import sys
sys.path.append(r'c:\ai\source\pylib')
from sample_pac.ab import a
# python -m sample_pac.cd.c

#
#from ..ab import a

def nice():
    print('sample_pac/cd  패키지 안의 c 모듈안의 nice')
    a.hello()
    
if __name__=='__main__':
    nice()