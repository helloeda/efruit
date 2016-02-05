#include"stdafx.h" 
//类 
typedef struct
{
    char userName[10];    //用户名
    char password[10];    //密码
    int group;            //用户组
} User;

typedef struct
{
    int fileStyle;         //文件类型0为目录文件，1为正规文件
    int fileMod;            //读写模式(1:read, 2:write, 3:exe)
    int fileAddress[13];   //文件存储的物理块
    int fileLength;		   //文件长度
    int fileAssociated;    //关联文件数
    char *modifyTime;     //文件修改时间
    char fileOwner[10];    //文件拥有者
    int fileGroup;		   //文件所属组

} Inode;

typedef struct
{
    int n;      //空闲的盘快的个数
    char free[512];    //存放空闲盘快的地址
    int a;      //模拟盘快是否被占用
} Block;

typedef struct
{
    int n;      //空闲的盘快的个数
    int free[512];    //存放进入栈中的空闲块
} Super_Block;

typedef struct
{
    int inum;				// i节点号
    char  file_name[10];		// 文件名
    char  dir_name[10];			//路径名 
} Directory;

typedef struct
{
    int inum;				// i节点号
    int fileMod;			// 读写模式(1:read, 2:write, 3:read and write)
} File_table;


char	choice;		// y确定 n不是 
int		argc;		// 用户命令的参数个数
char	*argv[5];		// 用户命令的参数
char	temp[530];	// 缓冲区
User	user;		// 当前的用户
Block	block[529];
Super_Block super_block;
Inode	inode_array[256];	// i节点数组
Directory dir[256];	// 打开文件表数组
char 	image_name[13] = "system.txt";	// 文件系统名称
FILE		*fp;					// 打开文件指针
File_table file_array[10];			//打开文件表 
int defaultMask=2;			//设置屏蔽码 
int physic[13];    //文件地址缓冲区
int style=1;     //文件的类型
char cur_dir[10]="root";  //当前目录

void Format()     //格式化
{
	
    printf("Will be to format filesystem...\n");
    printf("WARNING:ALL DATA ON THIS FILESYSTEM WILL BE LOST!\n");
    printf("Proceed with Format(Y/N)?");
    scanf("%c", &choice);
    if((choice == 'y') || (choice == 'Y'))
    {
        if((fp=fopen(image_name, "w+b")) == NULL)
        {
            printf("Can't create file %s\n", image_name);
            exit(-1);
        }

        int i,j,k;
        super_block.n=23;
        for(i=0; i<23; i++)   //超级块初始化
        {
            super_block.free[i]=i;   //存放进入栈中的空闲块
        }
        for(i=0; i<256; i++)   //i结点信息初始化
        {
            inode_array[i].fileStyle=-1;     //-1=普通文件；0=目录文件
            inode_array[i].fileMod=-1;
            for(int i=0; i<13; i++)
                inode_array[i].fileAddress[i]=-1;
            inode_array[i].fileLength=-1;
            inode_array[i].fileAssociated=0;
            strcpy(inode_array[i].fileOwner,"");
            inode_array[i].fileGroup=-1;
        }
        for(i=0; i<256; i++)   //根目录区信息初始化
        {
            strcpy(dir[i].file_name,"");
            dir[i].inum=-1;
            strcpy(dir[i].dir_name,"");
        }
        
        for(i = 0; i < 8; i++){
        	file_array[i].inum=-1;
        	file_array[i].fileMod=-1;
        }
			

        
        for(i=0; i<529; i++)   //存储空间初始化
        {
            block[i].n=0;      //必须有这个
            block[i].a=0;
            for(j=0; j<529; j++)
            {
                block[i].free[j]=-1;
            }
        }
        for(i=0; i<529; i++)  //将空闲块的信息用成组链接的方法写进每组的最后一个块中
        {
            //存储空间初始化

            if((i+1)%23==0)
            {
                k=i+1;
                for(j=0; j<23; j++)
                {
                    if(k<530)
                    {
                        block[i].free[j]=k;//下一组空闲地址
                        block[i].n++;  //下一组空闲个数   注意在memory[i].n++之前要给其赋初值
                        k++;
                    }
                    else
                    {
                        block[i].free[j]=-1;
                    }
                }
                block[i].a=0;    //标记为没有使用
                continue;     //处理完用于存储下一组盘块信息的特殊盘块后，跳过本次循环
            }
            for(j=0; j<23; j++)
            {
                block[i].free[j]=-1;
            }
            block[i].n=0;
        }
        if((fp=fopen("user.txt", "w+")) == NULL)
        {
            printf("Can't create file %s\n", "user.txt");
            exit(-1);
        }
        fclose(fp);
		
        fp=fopen("system.txt","wb");
        for(i=0; i<529; i++)
        {
            fwrite(&block[i],sizeof(Block),1,fp);
        }
        fwrite(&super_block,sizeof(Super_Block),1,fp);
        for(i=0; i<256; i++)
        {
            fwrite(&inode_array[i],sizeof(Inode),1,fp);
        }
        for(i=0; i<256; i++)
        {
            fwrite(&dir[i],sizeof(Directory),1,fp);
        }
        fclose(fp);

        printf("已经初始化完毕\n");
        printf("进入UNIX文件模拟............\n\n");
    }
}


// 功能: 用户登陆，如果是新用户则创建用户
    void Login(void)
    {
        char *p;
        int  flag;
        int group;
        char userName[10];
        char password[10];
        char file_name[10] = "user.txt";
        do
        {
            printf("login    :");
			 gets(userName);
			printf("                        password :");
           
            p=password;
            while(*p=getch())
            {
                if(*p == 0x0d) //当输入回车键时，0x0d为回车键的ASCII码
                {
                    *p='\0'; //将输入的回车键转换成空格
                    break;
                }
                printf("*");   //将输入的密码以"*"号显示
                p++;
            }
            flag = 0;
            if((fp = fopen(file_name, "r+")) == NULL)
            {
            	system("cls");
                printf("\nCan't open file %s.\n", file_name);
                printf("This filesystem not exist, it will be create!\n");
                Format();
                Login();
            }
            while(!feof(fp))
            {
                fread(&user, sizeof(User), 1, fp);
// 已经存在的用户, 且密码正确
                if(!strcmp(user.userName,userName) &&
                        !strcmp(user.password, password))
                {
                    fclose(fp);
                    printf("\n");
                    return ;
                }
// 已经存在的用户, 但密码错误
                else if(!strcmp(user.userName, userName))
                {
                    printf("\nThis user is exist, but password is incorrect.\n");
                    flag = 1;
                    fclose(fp);
                    break;
                }
            }
            if(flag == 0) break;
        }
        while(flag);
// 创建新用户
        if(flag == 0)
        {
            printf("\nDo you want to creat a new user?(y/n):");
            scanf("%c", &choice);
            gets(temp);
            if((choice == 'y') || (choice == 'Y'))
            {
                printf("group:");
                scanf("%d",&group);
                strcpy(user.userName, userName);
                strcpy(user.password, password);
                user.group=group;
                fwrite(&user, sizeof(User), 1, fp);
                fclose(fp);
                return ;
            }
            if((choice == 'n') || (choice == 'N'))
                Login();
        }
    }


    void write_file(FILE *fp)    //将信息写系统文件中
    {
        int i;
        fp=fopen("system.txt","wb");
        for(i=0; i<529; i++)
        {
            fwrite(&block[i],sizeof(Block),1,fp);
        }
        fwrite(&super_block,sizeof(Super_Block),1,fp);
        for(i=0; i<256; i++)
        {
            fwrite(&inode_array[i],sizeof(Inode),1,fp);
        }
        for(i=0; i<256; i++)
        {
            fwrite(&dir[i],sizeof(Directory),1,fp);
        }
        fclose(fp);
    }


    void read_file(FILE *fp)   //读出系统文件的信息
    {
        int i;
        fp=fopen("system.txt","rb");
        for(i=0; i<529; i++)
        {
            fread(&block[i],sizeof(Block),1,fp);
        }
        fread(&super_block,sizeof(Super_Block),1,fp);
        for(i=0; i<256; i++)
        {
            fread(&inode_array[i],sizeof(Inode),1,fp);
        }
        for(i=0; i<256; i++)
        {
            fread(&dir[i],sizeof(Directory),1,fp);
        }
        fclose(fp);
    }


    void callback(int length)    //回收磁盘空间
    {
        int i,j,k,m,q=0;
        for(i=length-1; i>=0; i--)
        {
            k=physic[i];     //需要提供要回收的文件的地址
            m=22-super_block.n;    //回收到栈中的哪个位置
            if(super_block.n==23)   //注意 当super_block.n==50时 m=-1;的值
            {
                //super_block.n==50的时候栈满了，要将这个栈中的所有地址信息写进下一个地址中
                for(j=0; j<23; j++)
                {
                    block[k].free[j]=super_block.free[j];
                }
                super_block.n=0;
                block[k].n=23;
            }
            block[k].a=0;
            if(m==-1)
            {
                m=22;      //将下一个文件地址中的盘块号回收到栈底中，这个地址中存放着刚才满栈的地址的信息
            }
            super_block.free[m]=physic[i]; //将下一个文件地址中的盘块号回收到栈中
            super_block.n++;
        }
    }
    void allot(int length)     //分配空间
    {
        int i,j,k,m,p;
        for(i=0; i<length; i++)
        {
            k=23-super_block.n;    //超级块中表示空闲块的指针
            m=super_block.free[k];   //栈中的相应盘块的地址
            p=super_block.free[22];   //栈中的最后一个盘块指向的地址
            if(m==-1||block[p].a==1)  //检测是否还有下一组盘块
            {
                printf("内存不足,不能够分配空间\n");
                callback(length);
                break;
            }
            if(super_block.n==1)
            {
                block[m].a=1;    //将最后一个盘块分配掉
                physic[i]=m;
                super_block.n=0;
                for(j=0; j<block[m].n; j++) //从最后一个盘块中取出下一组盘块号写入栈中
                {
                    super_block.free[j]=block[m].free[j];
                    super_block.n++;
                }
                continue;     //要跳过这次循环，下面的语句在IF中已经执行过
            }
            physic[i]=m;     //栈中的相应盘块的地址写进 文件地址缓冲区
            block[m].a=1;
            super_block.n--;
        }
    }


    int analyse(char *str)
    {
        int  i;
        char temp[20];
        char *ptr_char;
        char  *syscmd[]= {"help", "Ls", "Chmod", "Chown", "Chgrp", "Pwd", "Cd", "Mkdir", "Rmdir", "Umask", "Move","Rename", "Cp",
                          "Mkfile","Rmfile","Ln","Passwd", "Open", "Read", "Write", "Close","Logout", "Clear","Format","Quit","Cat"
                         };
        argc = 0;
        for(i = 0, ptr_char = str; *ptr_char != '\0'; ptr_char++)
        {
            if(*ptr_char != ' ')
            {
                while(*ptr_char != ' ' && (*ptr_char != '\0'))
                    temp[i++] = *ptr_char++;
                argv[argc] = (char *)malloc(i+1);
                strncpy(argv[argc], temp, i);
                argv[argc][i] = '\0';
                argc++;
                i = 0;
                if(*ptr_char == '\0') break;
            }
        }
        if(argc != 0)
        {
            for(i = 0; (i < 25) && strcmp(argv[0], syscmd[i]); i++);
            return i;
        }
        else return 26;
    }


    void Mkfile(char filename[] ,int mod=0) //创建文件
    {
        int i,j;
        for(i=0; i<256; i++)
        {
            if(dir[i].inum==-1)
            {
                dir[i].inum=i;
                strcpy(dir[i].file_name,filename);
                strcpy(dir[i].dir_name,cur_dir);  //把当前目录名 给新建立的文件
                int k =dir[i].inum;
                inode_array[k].fileStyle=style;
                inode_array[k].fileLength=0;
                strcpy(inode_array[k].fileOwner,user.userName);
                inode_array[k].fileGroup=user.group;
                inode_array[k].fileMod=mod;
                time_t t;//定义一个时间变量
                t=time(NULL);
                char *time;//定义一个字符串用来保存获取到的日期和时间
                time=ctime(&t);//赋值
                inode_array[k].modifyTime=time;
                break;
            }
        }
        for(i=0; i<256; i++)
        {
            if(dir[i].dir_name==cur_dir)
                inode_array[dir[i].inum].fileLength++;
        }
        
        write_file(fp);
    }


    void Mkdir(void)    //创建目录
    {
        style=0;         //0代表文件类型是目录文件
        Mkfile(argv[1],0);
        style=1;         //用完恢复初值，因为全局变量，否则
    }


    void Rmfile(char filename[])     //删除文件
    {
        int i,j,k;
        for(i=0; i<256; i++)
        {

            if(strcmp(filename,dir[i].file_name)==0)
            {
                k=dir[i].inum;
                for(j=0; j<inode_array[k].fileLength; j++)
                {
                    physic[j]=inode_array[k].fileAddress[j];
                }
                callback(inode_array[k].fileLength); //调用 回收函数
                for(j=0; j<13; j++)   //删除文件后要将文件属性和目录项的各个值恢复初值
                {
                    inode_array[k].fileAddress[j]=-1; //地址恢复初值
                }
                strcpy(dir[i].file_name,"");  //文件名恢复初值
                dir[i].inum=-1;     //目录项的I结点信息恢复初值
                strcpy(dir[i].dir_name,"");  //目录项的文件目录信息恢复初值
                inode_array[k].fileStyle==-1;
                inode_array[k].fileLength==-1;
                strcpy(inode_array[k].fileOwner,"");
                inode_array[k].fileGroup==-1;
                inode_array[k].fileMod==-1;
                break;
            }
        }
        if(i==256)
        {
            printf("不存在这个文件\n");
        }
    }


    void Rmdir(void)     //删除目录   需要判断目录下时候为空,不为空就不删除
    {
        int i,j,k;
        for(i=0; i<256; i++)     //还要加条件判断要删除的目录是不是当前目录
        {
            k=dir[i].inum;      //找到目录名字
            if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,argv[1])!=0 && (inode_array[k].fileStyle)==0 )
            {

                for(j=0; j<256; j++)
                {
                    if(strcmp(argv[1],dir[j].dir_name)==0)
                    {
                        printf("目录不为空不能直接删除\n");
                        break;
                    }
                }
                if(j==256)
                {
                    Rmfile(argv[1]);
                    break;
                }

                break;
            }
        }
        if(i==256)
        {
            printf("这个不是目录文件 或者不存在这个目录,或者你要删除的是当前目录\n");
        }

    }

    void Pwd()         //显示当前目录下的文件列表
    {
        int i,k;
        printf("\t\t文件名字  文件类型  文件长度  所属目录\n");
        for(i=0; i<256; i++)
        {
            k=dir[i].inum;
            if((strcmp(cur_dir,dir[i].dir_name)==0)&&(inode_array[k].fileStyle==1))   //查询文件中 所在目录信息和当前目录信息相同的数据
            {

                printf("\t\t  %s\t",dir[i].file_name);  //文件名
                printf("%d\t",inode_array[k].fileStyle);  //文件的类型
                printf("%d\t",inode_array[k].fileLength);  //文件的长度
                printf("%s\n",dir[i].dir_name);   //文件所在的目录
            }
        }
    }

    void Ls()         //显示当前目录下的文件列表
    {
        int i,k;
        int flag=0;
        printf("文件名字  文件类型  文件长度  所属目录  所属组 关联数    修改时间    \n");
        for(i=0; i<256; i++)
        {
            k=dir[i].inum;
            if((strcmp(cur_dir,dir[i].dir_name)==0))   //查询文件中 所在目录信息和当前目录信息相同的数据
            {
                flag=1;
                printf("%s\t",dir[i].file_name);  //文件名
                printf("%d\t",inode_array[k].fileStyle);  //文件的类型
                printf("%d\t",inode_array[k].fileLength);  //文件的长度
                printf("%s ",dir[i].dir_name);   //文件所在的目录
				printf("%d\t",inode_array[k].fileGroup);  //文件所属组
                printf("%d\n",inode_array[k].fileAssociated);  //文件关联数
                printf("%s\t",inode_array[k].modifyTime);   //文件修改时间
                
            }
        }
        if(flag==0)
            printf("it is empty! \n");
    }

    void Cd(void)     //进入指定的目录
    {
        int i,k;
        if(argc != 2)
        {
            printf("Command cd must have two args. \n");
            return ;
        }
        if(!strcmp(argv[1], ".."))
        {
            for(i=0; i<256; i++)     //查询和当前目录名相同的目录文件名
            {
                k=dir[i].inum;
                if(strcmp(cur_dir,dir[i].file_name)==0 && (inode_array[k].fileStyle==0))
                    strcpy(cur_dir,dir[i].dir_name); //将查询到的目录文件名  所在的目录赋值给当前目录
            }
            return;
        }

        else
        {
            for(i=0; i<256; i++)
            {
                k=dir[i].inum;      //判断文件类型是不是目录类型
                if((strcmp(argv[1],dir[i].file_name)==0) && (inode_array[k].fileStyle==0))
                {
                    strcpy(cur_dir,argv[1]);    //将要进入的指定目录设置为当前目录  赋值不要反了strcpy(目的，源)
                    break;
                }
            }
        }

        if(i==256)
        {
            printf("没有这个目录\n");
        }
    }


    void Open(void)        //打开文件
    {
        int i,j,k;
		int priority;
        for(i=0; i<256; i++)
        {
            k=dir[i].inum;
            if((strcmp(argv[1],dir[i].file_name)==0) && (inode_array[k].fileStyle==1)&&(strcmp(dir[i].dir_name,cur_dir)==0))
            {
                if(inode_array[k].fileGroup==user.group)
                {
                    bool flag=false;
                    
                    for( int j=0; j<8; j++)
                    {
                        if ((file_array[j].inum!=-1)&&(file_array[j].inum==k))
                        {
                            flag =true;
                            printf("重复打开或打开文件数量过多,请关闭些许. \n");
                        }
                    }
                    if (!flag)
                    {
                        for (int x=0; x<8; x++) //遍历
                        {
                            if (file_array[x].inum==-1)
                            {
                            	file_array[x].inum=k;
                                file_array[x].fileMod=inode_array[k].fileMod;
                                break;
                            }
                        }

                    }
                    if(inode_array[k].fileOwner==user.userName)
                        priority=3;
                    else
                        priority=2;

                }
                else
                priority=1;
                
                printf("Open file %s ", dir[i].file_name);
                if(priority == 1){
                	printf("\n you don't have enough priority to open.\n");
                	return;
                } 
                else if(priority == 2) printf("\n you may read and write\n");
                else printf("\n you can read and write and copy.\n");
                break;
            }
        }
        if(i==256)
        {
            printf("没有这个文件 或者这个文件不是正规文件\n");
        }
    }

    void Write()
    {
        int i,j, inum, length, block_num;
        if(argc != 2)
        {
            printf("Command write must have one args. \n");
            return ;
        }
        for(i = 0; i < 8; i++)
            if((file_array[i].inum>0)&&!strcmp(dir[file_array[i].inum].file_name,argv[1])) break;
        if(i == 8)
        {
            printf("Open %s first.\n", argv[1]);
            return ;
        }
        
        inum = file_array[i].inum;
        if(inode_array[inum].fileMod ==0)
        {
        	printf("this file can only read! \n");
        	return;
        }
        if(inode_array[inum].fileLength == 0)
        {
            printf("Input the data(Enter to end):\n");
            gets(temp);
            length = strlen(temp);
            if((length < 0) && (length >1024))
            {
                printf("Input wrong.\n");
                return ;
            }
            if (length%512 == 0)
                block_num=(int)length/512;
            else
                block_num=(int)length/512+1;

            inode_array[inum].fileLength = length;

            time_t t;//定义一个时间变量
            t=time(NULL);
            char *time;//定义一个字符串用来保存获取到的日期和时间
            time=ctime(&t);//赋值
            inode_array[inum].modifyTime=time;

            allot(block_num);
            for(j=0; j<block_num; j++)
            {
                inode_array[inum].fileAddress[j]=physic[j];
            }
            int num,index;
            num=512;
            index=0;
            for (int i=0; i<block_num; i++)
            {
                if (i==block_num-1)
                {
                    num=length%512;
                }
				for(int a=0;a<num;a++)
				block[inode_array[inum].fileAddress[i]].free[a]=temp[index+a];
                index+=num;
            }

        }
        else if(inode_array[inum].fileLength>0)
        {
        	int fileLength;
        	printf("已有数据存在,输入连在之后. \n");
       	 	printf("Input the data(Enter to end):\n");
            gets(temp);
            length = strlen(temp);        	            
           fileLength =inode_array[inum].fileLength;
           inode_array[inum].fileLength=fileLength+length;
        	 for(j=0; j<1; j++)
            {
                inode_array[inum].fileAddress[j]=physic[j];
            }
			for(int a=0;a<length;a++)
			block[inode_array[inum].fileAddress[0]].free[a+fileLength]=temp[a];
        }
        else
            printf("This file can't be written.\n");
    }

    void Read()
    {
        int i, start, num, inum;
        if(argc != 2)
        {
            printf("command read must have one args. \n");
            return;
        }
        for(i = 0; i < 8; i++)
            if((file_array[i].inum > 0) && !strcmp(dir[file_array[i].inum].file_name,argv[1]))
                break;
        if(i == 8)
        {
            printf("Open %s first.\n", argv[1]);
            return ;
        }

        inum = file_array[i].inum;
        printf("The length of %s:%d.\n", argv[1], inode_array[inum].fileLength);
        if(inode_array[inum].fileLength > 0)
        {
            printf("The start position:");
            scanf("%d", &start);
            gets(temp);
            if((start<0)||(start>=inode_array[inum].fileLength))
            {
                printf("Start position is wrong.\n");
                return;
            }
           
            int inode_num,length,block_num;
            int * add;
            length=inode_array[inum].fileLength;
            add=inode_array[inum].fileAddress;
            if (length%512==0)
                block_num=(int)length/512;
            else
                block_num=(int)length/512+1;
            int num =512;
            int index=0;
            for (i=0; i<block_num; i++)
            {
                if (i==block_num-1)
                {
                    num=length%512;
                }
               for(int a=0;a<num;a++)
				temp[index+a]=block[inode_array[inum].fileAddress[i]].free[a];
				index+=num;
            }
            for(i = 0; (i < num) && (temp[i] != '\0'); i++)
                printf("%c", temp[start+i]);
            printf("\n");
        }
    }


// 功能: 关闭已经打开的文件(close file1)
    void Close(void)
    {
        int i;
        if(argc != 2)
        {
            printf("Command close must have one args. \n");
            return ;
        }
        for(i = 0; i < 8; i++)
            if((file_array[i].inum > 0) &&
                    !strcmp(dir[file_array[i].inum].file_name, argv[1])) break;
        if(i == 8)
        {
            printf("This file doesn't be opened.\n");
            return ;
        }
        else
        {
            file_array[i].inum = -1;
            printf("Close %s successful!\n", argv[1]);
        }
    }

    void Rename(void)
    {
        int i,k,flag=0;
        //输入要修改文件名的文件名称
        printf("new name:");
        char Nname[10];
        gets(Nname);
        for(i=0; i<256; i++)     //还要加条件判断要删除的目录是不是当前目录
        {
            k=dir[i].inum;      //找到目录名字
            if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
            {
                flag=1;
                if(inode_array[k].fileGroup==user.group)
                {
                    strcpy(dir[i].file_name,Nname);
                    printf("OK");
                }
                else
                    printf("you dont't have priority");
            }

        }
        if(flag==0)
            printf("the file not exist!");
    }

    void Move(void)
    {
        int i,k,flag=0;
        //输入要修改文件路径 
        printf("which dir:");
        char Ndir[10];
        gets(Ndir);
        for(i=0; i<256; i++)     //还要加条件判断要删除的目录是不是当前目录
        {
            k=dir[i].inum;      //找到目录名字
            if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
            {
                flag=1;
                if(inode_array[k].fileGroup==user.group)
                {
                    strcpy(dir[i].dir_name,Ndir);
                    printf("OK");
                    for(i=0; i<256; i++)
                    {
                        if(dir[i].dir_name==cur_dir)
                            inode_array[dir[i].inum].fileLength++;
                    }
                }
                else
                    printf("you dont't have priority");
            }

        }
        if(flag==0)
            printf("the file not exist!");
    }


    void Chmod(void)
    {
        int i,k,flag=0;
        //输入要修改文件模式的文件名称
        printf("new mod(1 read,2 write,3 exe):");
        int Nmod;
        scanf("%d", &Nmod);

        for(i=0; i<256; i++)
        {
            k=dir[i].inum;      //找到目录名字
            if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
            {
                flag=1;
                if(inode_array[k].fileGroup==user.group)
                {
                    inode_array[k].fileMod=Nmod;
                    printf("OK");
                    time_t t;//定义一个时间变量
                    t=time(NULL);
                    char *time;//定义一个字符串用来保存获取到的日期和时间
                    time=ctime(&t);//赋值
                    inode_array[k].modifyTime=time;
                }
            }
        }
        if(flag==0)
            printf("the file not exist!");
    }

    void Chown(void)
    {
        //输入要修改文件所有者的文件名称
        int i,k;
        User checkName;
        printf("new ownerName:");
        char ownerName[10];
        gets(ownerName);
        char file_name[10] = "user.txt";
        if((fp = fopen(file_name, "r+")) == NULL)
        {
            printf("\nCan't open file %s.\n", file_name);
            return ;
        }
        while(!feof(fp))
        {
            fread(&checkName, sizeof(User), 1, fp);
// 已经存在的用户, 且密码正确
            if(!strcmp(checkName.userName,ownerName))
        {
            fclose(fp);
            break;
            }
            else
            {
                printf("\nThis user isn't exist.\n");
                fclose(fp);
                return;
            }
        }
            for(i=0; i<256; i++)
        {
            k=dir[i].inum;      //找到目录名字
                if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
                {
                    if(inode_array[k].fileGroup==user.group)
                    {
                        strcpy(inode_array[k].fileOwner,ownerName);
                    }
                    else
                        printf("you dont't have priority \n");
                }
            }
        }

        void Chgrp(void)
        {
            int i,k,flag=0;
            //输入要修改文件所属组的文件名称
            printf("new group:");
            int Ngroup;
            scanf("%d", &Ngroup);

            for(i=0; i<256; i++)
            {
                k=dir[i].inum;      //找到目录名字
                if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
                {
                    flag=1;
                    if(inode_array[k].fileGroup==user.group)
                    {
                        inode_array[k].fileGroup=Ngroup;
                        printf("OK\n");
                        time_t t;//定义一个时间变量
                        t=time(NULL);
                        char *time;//定义一个字符串用来保存获取到的日期和时间
                        time=ctime(&t);//赋值
                        inode_array[k].modifyTime=time;
                    }
                    else
                        printf("you dont't have priority \n");
                }
            }
            if(flag==0)
                printf("the file not exist!\n");
        }

        void Passwd(void)
        {

            printf("new Passwd:");
            char Npasswd1[10];
            char Npasswd2[10];
            gets(Npasswd1);
            printf("write again:");
            gets(Npasswd2);
            if(strcmp(Npasswd1,Npasswd2)==0)
            {
                strcpy(user.password,Npasswd1);
                fp = fopen("user.txt", "w+");
                fwrite(&user, sizeof(User), 1, fp);
                printf("OK!\n");
            }
            else
                printf("password are not same!\n");

        }


        void Umask()
        {
            printf("Insert new mask:1 read 2write 3exe ");

            int mask;
            scanf("%d",&mask);
            defaultMask=mask;
            printf("Change mask success!\n");
        }

        void Cp(void)
        {
            int i,inum;

				
            for(i=0; i<256; i++)
            {
            	
                if(strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
                {
                    inum=dir[i].inum;
                    break;
                }
            }
            
            	if(strcmp(inode_array[inum].fileOwner,user.userName)!=0)
            	{
	            	printf("you are not fileOwner! you can't copy! \n");
	            	return;
	            }
            
            if(i==256)
            {
                printf("the oldFile not exit \n");
                return;
            }

            printf("new fileName:");
            char fileName[10];
            gets(fileName);
            for(i=0; i<256; i++)
            {
                if(strcmp(fileName,dir[i].file_name)==0&&inode_array[inum].fileStyle==style)
                {
                    printf("文件已经存在，不允许建立重名的文件\n");
                    return;
                }
            }

            for(i=0; i<256; i++)
            {
                if(dir[i].inum==-1)
                {
                    dir[i].inum=i;
                    strcpy(dir[i].file_name,fileName);
                    strcpy(dir[i].dir_name,cur_dir);  //把当前目录名 给新建立的文件
                    int k =dir[i].inum;
                    inode_array[k].fileStyle=inode_array[inum].fileStyle;
                    inode_array[k].fileLength=inode_array[inum].fileLength;
                    strcpy(inode_array[k].fileOwner,inode_array[inum].fileOwner);
                    inode_array[k].fileGroup=inode_array[inum].fileGroup;
                    inode_array[k].fileMod=inode_array[inum].fileMod;
                    time_t t;//定义一个时间变量
                    t=time(NULL);
                    char *time;//定义一个字符串用来保存获取到的日期和时间
                    time=ctime(&t);//赋值
                    inode_array[k].modifyTime=time;
                    for(i=0;i<13;i++)
                    inode_array[k].fileAddress[i]=inode_array[inum].fileAddress[i];
                    for(i=0; i<256; i++)
                    {
                        if(dir[i].dir_name==cur_dir)
                            inode_array[dir[i].inum].fileLength++;
                    }
                    
                    int inode_num,length,block_num;
		            int * add;
          	 		length=inode_array[inum].fileLength;
		            add=inode_array[inum].fileAddress;
		            if (length%512==0)
		                block_num=(int)length/512;
		            else
		                block_num=(int)length/512+1;
		            int num =512;
		            int index=0;
		            int j;
		            for (j=0; j<block_num; j++)
		            {
		                if (j==block_num-1)
		                {
		                    num=length%512;
		                }
		               for(int a=0;a<num;a++)
						temp[index+a]=block[inode_array[inum].fileAddress[j]].free[a];
						index+=num;
		            }
		            allot(block_num);
		            for(j=0; j<block_num; j++)
		            {
		                inode_array[k].fileAddress[j]=physic[j];
		            }
		            num=512;
		            index=0;
		            for (j=0; j<block_num; j++)
		            {
		                if (j==block_num-1)
		                {
		                    num=length%512;
		                }
						for(int a=0;a<num;a++)
						block[inode_array[k].fileAddress[j]].free[a]=temp[index+a];
		                index+=num;
		            }
                    
                    
                }
            }


        }

        void Ln(void)
        {
            int i,num;

            for(i=0; i<256; i++)
            {
                if(strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
                {
                    num=dir[i].inum;
                    break;
                }
            }
            if(i==256)
            {
                printf("the oldFile not exit");
                return;
            }

            printf("new fileName:");
            char fileName[10];
            gets(fileName);
            for(i=0; i<256; i++)
            {
                if(strcmp(fileName,dir[i].file_name)==0&&inode_array[dir[i].inum].fileStyle==style)
                {
                    printf("文件已经存在，不允许建立重名的文件\n");
                    return;
                }
            }

            for(i=0; i<256; i++)
            {
                if(dir[i].inum==-1)
                {
                    dir[i].inum=i;
                    strcpy(dir[i].file_name,fileName);
                    strcpy(dir[i].dir_name,cur_dir);  //把当前目录名 给新建立的文件
                    int k =dir[i].inum;
                    inode_array[k].fileStyle=inode_array[num].fileStyle;
                    inode_array[k].fileLength=inode_array[num].fileLength;
                    strcpy(inode_array[k].fileOwner,inode_array[num].fileOwner);
                    inode_array[k].fileGroup=inode_array[num].fileGroup;
                    inode_array[k].fileMod=inode_array[num].fileMod;
                    inode_array[num].fileAssociated++;
                    inode_array[k].fileAssociated=inode_array[num].fileAssociated;
                    time_t t;//定义一个时间变量
                    t=time(NULL);
                    char *time;//定义一个字符串用来保存获取到的日期和时间
                    time=ctime(&t);//赋值
                    inode_array[num].modifyTime=time;
                    for(i=0;i<13;i++)
                    inode_array[k].fileAddress[i]=inode_array[num].fileAddress[i];
                    for(i=0; i<256; i++)
                    {
                        if(dir[i].dir_name==cur_dir)
                            inode_array[dir[i].inum].fileLength++;
                    }
                    break;
                }
            }


        }


// 功能: 退出当前用户(logout)
        void Logout()
        {
            char choice;
            printf("Do you want to exit this user(y/n)?");
            scanf("%c", &choice);
            gets(temp);
            if((choice == 'y') || (choice == 'Y'))
            {
                printf("\nCurrent user exited!\nPlease to login by other user!\n");
                Login();
            }
            return ;
        }

		void Cat(){
			int i, j, start, inumFirst, inumSecond;
        if(argc != 3)
        {
            printf("command read must have two args. \n");
            return;
        }
        for(i = 0; i < 8; i++)
            if((file_array[i].inum > 0) && !strcmp(dir[file_array[i].inum].file_name,argv[1]))
            {
            	inumFirst = file_array[i].inum;
				break;
            }
                
        for(j = 0; j < 8; j++)
            if((file_array[j].inum > 0) && !strcmp(dir[file_array[j].inum].file_name,argv[2]))
            {
            	inumSecond = file_array[j].inum;
				break;
            }

        if(i == 8)
        {
            printf("Open %s first.\n", argv[1]);
            return ;
        }
        if(j == 8)
        {
            printf("Open %s first.\n", argv[2]);
            return ;
        }

            int inode_num,length,block_num;
            int * add;
            length=inode_array[inumFirst].fileLength;
            add=inode_array[inumFirst].fileAddress;
            if (length%512==0)
                block_num=(int)length/512;
            else
                block_num=(int)length/512+1;
            int num =512;
            int index=0;
            for (i=0; i<block_num; i++)
            {
                if (i==block_num-1)
                {
                    num=length%512;
                }
               for(int a=0;a<num;a++)
				temp[index+a]=block[inode_array[inumFirst].fileAddress[i]].free[a];
				index+=num;
            }
            
            length=inode_array[inumSecond].fileLength;
            add=inode_array[inumSecond].fileAddress;
            if (length%512==0)
                block_num=(int)length/512;
            else
                block_num=(int)length/512+1;
            num =512;
            index=0;
            for (i=0; i<block_num; i++)
            {
                if (i==block_num-1)
                {
                    num=length%512;
                }
               for(int a=0;a<num;a++)
				temp[index+inode_array[inumFirst].fileLength+a]=block[inode_array[inumFirst].fileAddress[i]].free[a];
				index+=num;
            }
            
            for(i = 0; (i < num+inode_array[inumFirst].fileLength) && (temp[i] != '\0'); i++)
                printf("%c", temp[i]);
            printf("\n");

		}
		
        void Quit()
        {
            char choice;
            printf("Do you want to exist(y/n):");
            scanf("%c", &choice);
            gets(temp);
            write_file(fp);
            if((choice == 'y') || (choice == 'Y'))
                exit(0);
        }

        void pathset()
        {
            char path[50];
            int i,m,k;
            if(strcmp(cur_dir,"root")==0)
                strcpy(path,user.userName);
            else
            {
                for(i=0; i<256; i++)
                {
                    k=dir[i].inum;
                    if(strcmp(cur_dir,dir[i].file_name)==0 && (inode_array[k].fileStyle==0))
                    {
                        if(strcmp(dir[i].dir_name,"root")==0)
                        {
                            strcpy(path,user.userName);
                            strcat(path,"/");
                            strcat(path,dir[i].file_name);
                        }
                        else
                        {
                            for(m=0; m<256; m++)
                            {
                                k=dir[m].inum;
                                if(strcmp(dir[i].dir_name,dir[m].file_name)==0 && (inode_array[k].fileStyle==0))
                                {
                                    strcpy(path,user.userName);
                                    strcat(path,"/");
                                    strcat(path,dir[m].file_name);
                                    strcat(path,"/");
                                    strcat(path,dir[i].file_name);
                                }
                            }

                        }
                    }

                }
            }
            printf("%s>",path);
        }

        void help(void)
        {
            printf("command: \n\
		help		   	  帮助   \n\
		Clear		  	  清屏 \n\
		Mkdir		  	  创建目录   \n\
		Mkfile			  创建文件 \n\
		Open		   	  打开文件 \n\
		Read		   	  读文件 \n\
		Write		  	  写文件 \n\
		Close		  	  关闭文件 \n\
		Format		 	  格式化 \n\
		Logout		 	  注销 \n\
		Move			  移动 \n\
		Ls				  显示文件目录\n\
		Chmod			  改变文件权限 \n\
		Chown  	 		  改变文件拥有者\n\
		Chgrp			  改变文件所属组\n\
		Pwd				  显示当前目录\n\
		Cd				  改变当前目录\n\
		Rmdir			  删除目录\n\
		Rmfile			  删除文件\n\
		Umask			  文件创建屏蔽码\n\
		Rename			  改变文件名\n\
		Cp				  文件拷贝\n\
		Rmfile			  文件删除\n\
		Ln           	  建立文件联接\n\
		Cat				  连接显示文件内容\n\
		Passwd			  修改用户口令\n\
		Quit    		  保存退出\n");
        }



        void command(void)
        {
            char cmd[100];
            style=0;         //0代表文件类型是目录文件
        	Mkfile("dev",0);
        	Mkfile("user",0);
        	Mkfile("etc",0);
        	style=1;         //用完恢复初值，因为全局变量，否则
            system("cls");
            do
            {
                pathset();
                gets(cmd);
                switch(analyse(cmd))
                {
                case 0:
                    help();
                    break;
                case 1:
                    Ls();
                    break;
                case 2:
                    Chmod();
                    break;
                case 3:
                    Chown();
                    break;
                case 4:
                    Chgrp();
                    break;
                case 5:
                    Pwd();
                    break;
                case 6:
                    Cd();
                    break;
                case 7:
                    Mkdir();
                    break;
                case 8:
                    Rmdir();
                    break;
                case 9:
                    Umask();
                    break;
                case 10:
                    Move();
                    break;
                case 11:
                    Rename();
                    break;
                case 12:
                    Cp();
                    break;
                case 13:
                	printf("Input name:");
                	char filenamee[10];
                	gets(filenamee);
                	printf("Input mod:");
                	int modd;
                	scanf("%d",&modd);
                    Mkfile(filenamee,modd);
                    break;
                case 14:
                	printf("Input name:");
                	char filenamea[10];
                	gets(filenamea);
                    Rmfile(filenamea);
                    break;
                case 15:
                    Ln();
                    break;
                case 16:
                    Passwd();
                    break;
                case 17:
                    Open();
                    break;
                case 18:
                    Read();
                    break;
                case 19:
                    Write();
                    break;
                case 20:
                    Close();
                    break;
                case 21:
                    Logout();
                    break;
                case 22:
                    system("cls");
                    break;
                case 23:
                    Format();
                    break;
                case 24:
                    Quit();
                    break;
                case 25:
                    Cat();
                    break;

                default:
                    break;
                }
            }while(1);
            
        }
		
		void InterFace(void)
		{
			printf("\n\n\n\n\n\n\n");
			printf("                      --------------------------------------\n");
			printf("                        ");
		}
		
        int main(void)
        {
        	InterFace();
            Login();
            if((fp=fopen(image_name, "w+b")) != NULL)
	        {
	            read_file(fp);
	        }
            command();
            return 0;
        }
