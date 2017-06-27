SMC1602A(16*2)模拟口线接线方式
连接线图:	
       ---------------------------------------------------
       |LCM-----51   |	LCM-----51   |	LCM------51      |
       --------------------------------------------------|
       |DB0-----P1.0 |	DB4-----P1.4 |	RW-------P3.4    |
       |DB1-----P1.1 |	DB5-----P1.5 |	RS-------P3.3    |
       |DB2-----P1.2 |	DB6-----P1.6 |	E--------P3.5    |
       |DB3-----P1.3 |	DB7-----P1.7 |	VLCD接1K电阻到GND|
       ---------------------------------------------------
接线：模块TRIG接 P2.6  ECH0 接P2.7

本程序源码只供学习参考，不得应用于商业用途，如有需要请联系作者。

[注:AT89x51使用12M或11.0592M晶振,实测使用11.0592M]
=============================================================*/
#include <AT89x51.H>		//器件配置文件
#include <intrins.h>
#define  RX  P2_7
#define  TX  P2_6

#define LCM_RW  P3_4 //定义LCD引脚
#define LCM_RS  P3_3
#define LCM_E   P3_5
#define LCM_Data  P1

#define Key_Data P2_0 //定义Keyboard引脚
#define Key_CLK  P3_2

#define Busy    0x80 //用于检测LCM状态字中的Busy标识

void LCMInit(void);
void DisplayOneChar(unsigned char X, unsigned char Y, unsigned char DData);
void DisplayListChar(unsigned char X, unsigned char Y, unsigned char code *DData);
void Delay5Ms(void);
void Delay400Ms(void);
void Decode(unsigned char ScanCode);
void WriteDataLCM(unsigned char WDLCM);
void WriteCommandLCM(unsigned char WCLCM,BuysC);

unsigned char ReadDataLCM(void);
unsigned char ReadStatusLCM(void);
unsigned char code mcustudio[] ={"mcustudio.com.cn"};
unsigned char code email[] =    {"fhwxaoo@163.com "};
unsigned char code Cls[] =      {"                "};
unsigned char code ASCII[15] =    {'0','1','2','3','4','5','6','7','8','9','.','-','M'};

static unsigned char DisNum = 0; //显示用指针				  
       unsigned int  time=0;
	   unsigned long S=0;
	   bit      flag =0;
	   unsigned char disbuff[4]	   ={ 0,0,0,0,};


//写数据
void WriteDataLCM(unsigned char WDLCM) 
{
	ReadStatusLCM(); //检测忙
	LCM_Data = WDLCM;
	LCM_RS = 1;
	LCM_RW = 0;
	LCM_E = 0; //若晶振速度太高可以在这后加小的延时
	LCM_E = 0; //延时
	LCM_E = 1;
}

//写指令
void WriteCommandLCM(unsigned char WCLCM,BuysC) //BuysC为0时忽略忙检测
{
	if (BuysC) ReadStatusLCM(); //根据需要检测忙
	LCM_Data = WCLCM;
	LCM_RS = 0;
	LCM_RW = 0;	
	LCM_E = 0;
	LCM_E = 0;
	LCM_E = 1;	
}

//读数据
unsigned char ReadDataLCM(void)
{
	LCM_RS = 1; 
	LCM_RW = 1;
	LCM_E = 0;
	LCM_E = 0;
	LCM_E = 1;
	return(LCM_Data);
}

//读状态
unsigned char ReadStatusLCM(void)
{
	LCM_Data = 0xFF; 
	LCM_RS = 0;
	LCM_RW = 1;
	LCM_E = 0;
	LCM_E = 0;
	LCM_E = 1;
	while (LCM_Data & Busy); //检测忙信号
	return(LCM_Data);
}

void LCMInit(void) //LCM初始化
{
	LCM_Data = 0;
	WriteCommandLCM(0x38,0); //三次显示模式设置，不检测忙信号
	Delay5Ms(); 
	WriteCommandLCM(0x38,0);
	Delay5Ms(); 
	WriteCommandLCM(0x38,0);
	Delay5Ms(); 

	WriteCommandLCM(0x38,1); //显示模式设置,开始要求每次检测忙信号
	WriteCommandLCM(0x08,1); //关闭显示
	WriteCommandLCM(0x01,1); //显示清屏
	WriteCommandLCM(0x06,1); // 显示光标移动设置
	WriteCommandLCM(0x0F,1); // 显示开及光标设置
}

//按指定位置显示一个字符
void DisplayOneChar(unsigned char X, unsigned char Y, unsigned char DData)
{
	Y &= 0x1;
	X &= 0xF; //限制X不能大于15，Y不能大于1
	if (Y) X |= 0x40; //当要显示第二行时地址码+0x40;
	X |= 0x80; //算出指令码
	WriteCommandLCM(X, 1); //发命令字
	WriteDataLCM(DData); //发数据
}

//按指定位置显示一串字符
void DisplayListChar(unsigned char X, unsigned char Y, unsigned char code *DData)
{
	unsigned char ListLength;

  ListLength = 0;
	Y &= 0x1;
	X &= 0xF; //限制X不能大于15，Y不能大于1
	while (DData[ListLength]>0x19) //若到达字串尾则退出
		{
			if (X <= 0xF) //X坐标应小于0xF
				{
					DisplayOneChar(X, Y, DData[ListLength]); //显示单个字符
					ListLength++;
					X++;
				}
		}
}

//5ms延时
void Delay5Ms(void)
{
	unsigned int TempCyc = 5552;
	while(TempCyc--);
}

//400ms延时
void Delay400Ms(void)
{
	unsigned char TempCycA = 5;
	unsigned int TempCycB;
	while(TempCycA--)
		{
			TempCycB=7269;
			while(TempCycB--);
		};
}
/********************************************************/
    void Conut(void)
	{
	 time=TH0*256+TL0;
	 TH0=0;
	 TL0=0;
	
	 S=(time*1.7)/100;     //算出来是CM
	 if((S>=700)||flag==1) //超出测量范围显示“-”
	 {	 
	  flag=0;
	 
	  DisplayOneChar(0, 1, ASCII[11]);
	  DisplayOneChar(1, 1, ASCII[10]);	//显示点
	  DisplayOneChar(2, 1, ASCII[11]);
	  DisplayOneChar(3, 1, ASCII[11]);
	  DisplayOneChar(4, 1, ASCII[12]);	//显示M
	 }
	 else
	 {
	  disbuff[0]=S%1000/100;
	  disbuff[1]=S%1000%100/10;
	  disbuff[2]=S%1000%10 %10;
	  DisplayOneChar(0, 1, ASCII[disbuff[0]]);
	  DisplayOneChar(1, 1, ASCII[10]);	//显示点
	  DisplayOneChar(2, 1, ASCII[disbuff[1]]);
	  DisplayOneChar(3, 1, ASCII[disbuff[2]]);
	  DisplayOneChar(4, 1, ASCII[12]);	//显示M
	 }
	}
/********************************************************/
     void zd0() interrupt 1 		 //T0中断用来计数器溢出,超过测距范围
  {
    flag=1;							 //中断溢出标志
  }
/********************************************************/
     void  StartModule() 		         //启动模块
  {
	  TX=1;			                     //启动一次模块
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_();
	  _nop_(); 
	  _nop_(); 
	  _nop_(); 
	  _nop_();
	  TX=0;
  }
/********************************************************/ 
void delayms(unsigned int ms)
{
	unsigned char i=100,j;
	for(;ms;ms--)
	{
		while(--i)
		{
			j=10;
			while(--j);
		}
	}
}
/*********************************************************/
void main(void)
{
	unsigned char TempCyc;
	Delay400Ms(); //启动等待，等LCM讲入工作状态
	LCMInit(); //LCM初始化
	Delay5Ms(); //延时片刻(可不要)
	DisplayListChar(0, 0, mcustudio);
	DisplayListChar(0, 1, email);
	ReadDataLCM();//测试用句无意义
	for (TempCyc=0; TempCyc<10; TempCyc++)
	Delay400Ms(); //延时
	DisplayListChar(0, 1, Cls);	
	while(1)
	{
	 TMOD=0x01;		   //设T0为方式1，GATE=1；
	 TH0=0;
	 TL0=0;          
	 ET0=1;             //允许T0中断
	 EA=1;			   //开启总中断			
	
	while(1)
	  {
	     StartModule();
		// DisplayOneChar(0, 1, ASCII[0]);
	     while(!RX);		//当RX为零时等待
	     TR0=1;			    //开启计数
	     while(RX);			//当RX为1计数并等待
	     TR0=0;				//关闭计数
         Conut();			//计算
		 delayms(80);		//80MS
		 
	  }
	}
}



                