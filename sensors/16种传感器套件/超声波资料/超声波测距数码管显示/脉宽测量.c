/***********************************************************************************************************/
//hc-sr04 超声波测距模块 DEMO 程序
//晶振：11。0592
//接线：模块TRIG接 P0.2  ECH0 接P0.1
//数码管：共阳数码管P1接数据口,P2.5 P2.4 P2.3接选通数码管
/***********************************************************************************************************/	    
		     #include <AT89x51.H>		//器件配置文件
			 #include <intrins.h>
			 #define  RX  P0_1
			 #define  TX  P0_2
			 unsigned int  time=0;
			 unsigned int  timer=0;
			 unsigned char posit=0;
			 unsigned long S=0;
			 bit      flag =0;
			 unsigned char const discode[] ={ 0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90,0xBF,0xff/*-*/};
			 unsigned char const positon[3]={ 0xdf,0xef,0xf7};
			 unsigned char disbuff[4]	   ={ 0,0,0,0,};
/********************************************************/
    void Display(void)				 //扫描数码管
	{
	 if(posit==0)
	 {P1=(discode[disbuff[posit]])&0x7f;}
	 else
	 {P1=discode[disbuff[posit]];}
	  P2=positon[posit];
	  if(++posit>=3)
	  posit=0;
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
	  disbuff[0]=10;	   //“-”
	  disbuff[1]=10;	   //“-”
	  disbuff[2]=10;	   //“-”
	 }
	 else
	 {
	  disbuff[0]=S%1000/100;
	  disbuff[1]=S%1000%100/10;
	  disbuff[2]=S%1000%10 %10;
	 }
	}
/********************************************************/
     void zd0() interrupt 1 		 //T0中断用来计数器溢出,超过测距范围
  {
    flag=1;							 //中断溢出标志
  }
/********************************************************/
   void  zd3()  interrupt 3 		 //T1中断用来扫描数码管和计800MS启动模块
  {
	 TH1=0xf8;
	 TL1=0x30;
	 Display();
	 timer++;
	 if(timer>=400)
	 {
	  timer=0;
	  TX=1;			                //800MS  启动一次模块
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
  }
/*********************************************************/

	void  main(  void  )

  {  
    TMOD=0x11;		   //设T0为方式1，GATE=1；
	TH0=0;
	TL0=0;          
	TH1=0xf8;		   //2MS定时
	TL1=0x30;
	ET0=1;             //允许T0中断
	ET1=1;			   //允许T1中断
	TR1=1;			   //开启定时器
	EA=1;			   //开启总中断

	while(1)
	{
	 while(!RX);		//当RX为零时等待
	 TR0=1;			    //开启计数
	 while(RX);			//当RX为1计数并等待
	 TR0=0;				//关闭计数
     Conut();			//计算
	}

  }
                