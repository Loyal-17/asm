本文展示如何用布尔运算实现减法运算，以8位为例。

假设有两个8位2进制数 A - B：  
    A = a<sub>7</sub>a<sub>6</sub>a<sub>5</sub>a<sub>4</sub>a<sub>3</sub>a<sub>2</sub>a<sub>1</sub>a<sub>0</sub>  
    B = b<sub>7</sub>b<sub>6</sub>b<sub>5</sub>b<sub>4</sub>b<sub>3</sub>b<sub>2</sub>b<sub>1</sub>b<sub>0</sub>
    
我们考虑每位相加的情况，先看看 a<sub>0</sub> - b<sub>0</sub> ：
    
|a<sub>0</sub>  | b<sub>0</sub>| R<sub>0</sub>(结果位值)|C<sub>0</sub>（借位值）|
| ------------- | -------------|-----------------------|----------------------|
| 0             | 0            |  0                    |  0                   |
| 0             | 1            |  1                    |  1                   |
| 1             | 0            |  1                    |  0                   |
| 1             | 1            |  0                    |  0                   |

则：
**R<sub>0</sub> = a<sub>0</sub>  OXR b<sub>0</sub>，C<sub>0</sub> = a<sub>0</sub> AND b<sub>0</sub>**

再继续看 a<sub>1</sub> - b<sub>1</sub> ，此时要多考虑一个借位C<sub>0</sub>：

|a<sub>1</sub>  | b<sub>1</sub>| C<sub>0</sub>|R<sub>1</sub>|C<sub>1</sub>|
| ------------- | -------------|------------- |-------------|-------------|
| 0             | 0            |  0           |  0          |  0          |
| 0             | 0            |  1           |  1          |  1          |
| 0             | 1            |  0           |  1          |  1          |
| 0             | 1            |  1           |  0          |  1          |  
| 1             | 0            |  0           |  1          |  0          |
| 1             | 0            |  1           |  0          |  0          |
| 1             | 1            |  0           |  0          |  0          |
| 1             | 1            |  1           |  1          |  1          |  

则：**R<sub>1</sub> = (a<sub>1</sub> OXR b<sub>1</sub>) OXR C<sub>0</sub>，C<sub>1</sub> = NOT a<sub>1</sub> AND ( b<sub>1</sub> OR C<sub>0</sub>) OR (a<sub>1</sub> AND b<sub>1</sub> AND C<sub>0</sub>)**

注：异或（OXR）相当于不考虑借位的减法；**NOT a<sub>1</sub> AND ( b<sub>1</sub> OR C<sub>0</sub>) OR (a<sub>1</sub> AND b<sub>1</sub> AND C<sub>0</sub>)** 的意思是当a<sub>1</sub>=0时，b<sub>1</sub> 和 c<sub>0</sub>
只要有一个1就需要借位；当a<sub>1</sub>=1时，b<sub>1</sub> 和 c<sub>0</sub>都要为1才需要借位。

其它位同样如此，总结如下：  

**R<sub>n</sub> = (a<sub>n</sub> OXR b<sub>n</sub>) OXR C<sub>n-1</sub>，  
C<sub>n</sub> = NOT a<sub>n</sub> AND ( b<sub>n</sub> OR C<sub>n-1</sub>) OR (a<sub>n</sub> AND b<sub>n</sub> AND C<sub>n-1</sub>)**

注：n>0，C<sub>0</sub>=0。

至此，逻辑运算至算术运算减法得以成立。
