#include"stdafx.h" 
//�� 
typedef struct
{
    char userName[10];    //�û���
    char password[10];    //����
    int group;            //�û���
} User;

typedef struct
{
    int fileStyle;         //�ļ�����0ΪĿ¼�ļ���1Ϊ�����ļ�
    int fileMod;            //��дģʽ(1:read, 2:write, 3:exe)
    int fileAddress[13];   //�ļ��洢�������
    int fileLength;		   //�ļ�����
    int fileAssociated;    //�����ļ���
    char *modifyTime;     //�ļ��޸�ʱ��
    char fileOwner[10];    //�ļ�ӵ����
    int fileGroup;		   //�ļ�������

} Inode;

typedef struct
{
    int n;      //���е��̿�ĸ���
    char free[512];    //��ſ����̿�ĵ�ַ
    int a;      //ģ���̿��Ƿ�ռ��
} Block;

typedef struct
{
    int n;      //���е��̿�ĸ���
    int free[512];    //��Ž���ջ�еĿ��п�
} Super_Block;

typedef struct
{
    int inum;				// i�ڵ��
    char  file_name[10];		// �ļ���
    char  dir_name[10];			//·���� 
} Directory;

typedef struct
{
    int inum;				// i�ڵ��
    int fileMod;			// ��дģʽ(1:read, 2:write, 3:read and write)
} File_table;


char	choice;		// yȷ�� n���� 
int		argc;		// �û�����Ĳ�������
char	*argv[5];		// �û�����Ĳ���
char	temp[530];	// ������
User	user;		// ��ǰ���û�
Block	block[529];
Super_Block super_block;
Inode	inode_array[256];	// i�ڵ�����
Directory dir[256];	// ���ļ�������
char 	image_name[13] = "system.txt";	// �ļ�ϵͳ����
FILE		*fp;					// ���ļ�ָ��
File_table file_array[10];			//���ļ��� 
int defaultMask=2;			//���������� 
int physic[13];    //�ļ���ַ������
int style=1;     //�ļ�������
char cur_dir[10]="root";  //��ǰĿ¼

void Format()     //��ʽ��
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
        for(i=0; i<23; i++)   //�������ʼ��
        {
            super_block.free[i]=i;   //��Ž���ջ�еĿ��п�
        }
        for(i=0; i<256; i++)   //i�����Ϣ��ʼ��
        {
            inode_array[i].fileStyle=-1;     //-1=��ͨ�ļ���0=Ŀ¼�ļ�
            inode_array[i].fileMod=-1;
            for(int i=0; i<13; i++)
                inode_array[i].fileAddress[i]=-1;
            inode_array[i].fileLength=-1;
            inode_array[i].fileAssociated=0;
            strcpy(inode_array[i].fileOwner,"");
            inode_array[i].fileGroup=-1;
        }
        for(i=0; i<256; i++)   //��Ŀ¼����Ϣ��ʼ��
        {
            strcpy(dir[i].file_name,"");
            dir[i].inum=-1;
            strcpy(dir[i].dir_name,"");
        }
        
        for(i = 0; i < 8; i++){
        	file_array[i].inum=-1;
        	file_array[i].fileMod=-1;
        }
			

        
        for(i=0; i<529; i++)   //�洢�ռ��ʼ��
        {
            block[i].n=0;      //���������
            block[i].a=0;
            for(j=0; j<529; j++)
            {
                block[i].free[j]=-1;
            }
        }
        for(i=0; i<529; i++)  //�����п����Ϣ�ó������ӵķ���д��ÿ������һ������
        {
            //�洢�ռ��ʼ��

            if((i+1)%23==0)
            {
                k=i+1;
                for(j=0; j<23; j++)
                {
                    if(k<530)
                    {
                        block[i].free[j]=k;//��һ����е�ַ
                        block[i].n++;  //��һ����и���   ע����memory[i].n++֮ǰҪ���丳��ֵ
                        k++;
                    }
                    else
                    {
                        block[i].free[j]=-1;
                    }
                }
                block[i].a=0;    //���Ϊû��ʹ��
                continue;     //���������ڴ洢��һ���̿���Ϣ�������̿����������ѭ��
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

        printf("�Ѿ���ʼ�����\n");
        printf("����UNIX�ļ�ģ��............\n\n");
    }
}


// ����: �û���½����������û��򴴽��û�
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
                if(*p == 0x0d) //������س���ʱ��0x0dΪ�س�����ASCII��
                {
                    *p='\0'; //������Ļس���ת���ɿո�
                    break;
                }
                printf("*");   //�������������"*"����ʾ
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
// �Ѿ����ڵ��û�, ��������ȷ
                if(!strcmp(user.userName,userName) &&
                        !strcmp(user.password, password))
                {
                    fclose(fp);
                    printf("\n");
                    return ;
                }
// �Ѿ����ڵ��û�, ���������
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
// �������û�
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


    void write_file(FILE *fp)    //����Ϣдϵͳ�ļ���
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


    void read_file(FILE *fp)   //����ϵͳ�ļ�����Ϣ
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


    void callback(int length)    //���մ��̿ռ�
    {
        int i,j,k,m,q=0;
        for(i=length-1; i>=0; i--)
        {
            k=physic[i];     //��Ҫ�ṩҪ���յ��ļ��ĵ�ַ
            m=22-super_block.n;    //���յ�ջ�е��ĸ�λ��
            if(super_block.n==23)   //ע�� ��super_block.n==50ʱ m=-1;��ֵ
            {
                //super_block.n==50��ʱ��ջ���ˣ�Ҫ�����ջ�е����е�ַ��Ϣд����һ����ַ��
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
                m=22;      //����һ���ļ���ַ�е��̿�Ż��յ�ջ���У������ַ�д���Ÿղ���ջ�ĵ�ַ����Ϣ
            }
            super_block.free[m]=physic[i]; //����һ���ļ���ַ�е��̿�Ż��յ�ջ��
            super_block.n++;
        }
    }
    void allot(int length)     //����ռ�
    {
        int i,j,k,m,p;
        for(i=0; i<length; i++)
        {
            k=23-super_block.n;    //�������б�ʾ���п��ָ��
            m=super_block.free[k];   //ջ�е���Ӧ�̿�ĵ�ַ
            p=super_block.free[22];   //ջ�е����һ���̿�ָ��ĵ�ַ
            if(m==-1||block[p].a==1)  //����Ƿ�����һ���̿�
            {
                printf("�ڴ治��,���ܹ�����ռ�\n");
                callback(length);
                break;
            }
            if(super_block.n==1)
            {
                block[m].a=1;    //�����һ���̿�����
                physic[i]=m;
                super_block.n=0;
                for(j=0; j<block[m].n; j++) //�����һ���̿���ȡ����һ���̿��д��ջ��
                {
                    super_block.free[j]=block[m].free[j];
                    super_block.n++;
                }
                continue;     //Ҫ�������ѭ��������������IF���Ѿ�ִ�й�
            }
            physic[i]=m;     //ջ�е���Ӧ�̿�ĵ�ַд�� �ļ���ַ������
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


    void Mkfile(char filename[] ,int mod=0) //�����ļ�
    {
        int i,j;
        for(i=0; i<256; i++)
        {
            if(dir[i].inum==-1)
            {
                dir[i].inum=i;
                strcpy(dir[i].file_name,filename);
                strcpy(dir[i].dir_name,cur_dir);  //�ѵ�ǰĿ¼�� ���½������ļ�
                int k =dir[i].inum;
                inode_array[k].fileStyle=style;
                inode_array[k].fileLength=0;
                strcpy(inode_array[k].fileOwner,user.userName);
                inode_array[k].fileGroup=user.group;
                inode_array[k].fileMod=mod;
                time_t t;//����һ��ʱ�����
                t=time(NULL);
                char *time;//����һ���ַ������������ȡ�������ں�ʱ��
                time=ctime(&t);//��ֵ
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


    void Mkdir(void)    //����Ŀ¼
    {
        style=0;         //0�����ļ�������Ŀ¼�ļ�
        Mkfile(argv[1],0);
        style=1;         //����ָ���ֵ����Ϊȫ�ֱ���������
    }


    void Rmfile(char filename[])     //ɾ���ļ�
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
                callback(inode_array[k].fileLength); //���� ���պ���
                for(j=0; j<13; j++)   //ɾ���ļ���Ҫ���ļ����Ժ�Ŀ¼��ĸ���ֵ�ָ���ֵ
                {
                    inode_array[k].fileAddress[j]=-1; //��ַ�ָ���ֵ
                }
                strcpy(dir[i].file_name,"");  //�ļ����ָ���ֵ
                dir[i].inum=-1;     //Ŀ¼���I�����Ϣ�ָ���ֵ
                strcpy(dir[i].dir_name,"");  //Ŀ¼����ļ�Ŀ¼��Ϣ�ָ���ֵ
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
            printf("����������ļ�\n");
        }
    }


    void Rmdir(void)     //ɾ��Ŀ¼   ��Ҫ�ж�Ŀ¼��ʱ��Ϊ��,��Ϊ�վͲ�ɾ��
    {
        int i,j,k;
        for(i=0; i<256; i++)     //��Ҫ�������ж�Ҫɾ����Ŀ¼�ǲ��ǵ�ǰĿ¼
        {
            k=dir[i].inum;      //�ҵ�Ŀ¼����
            if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,argv[1])!=0 && (inode_array[k].fileStyle)==0 )
            {

                for(j=0; j<256; j++)
                {
                    if(strcmp(argv[1],dir[j].dir_name)==0)
                    {
                        printf("Ŀ¼��Ϊ�ղ���ֱ��ɾ��\n");
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
            printf("�������Ŀ¼�ļ� ���߲��������Ŀ¼,������Ҫɾ�����ǵ�ǰĿ¼\n");
        }

    }

    void Pwd()         //��ʾ��ǰĿ¼�µ��ļ��б�
    {
        int i,k;
        printf("\t\t�ļ�����  �ļ�����  �ļ�����  ����Ŀ¼\n");
        for(i=0; i<256; i++)
        {
            k=dir[i].inum;
            if((strcmp(cur_dir,dir[i].dir_name)==0)&&(inode_array[k].fileStyle==1))   //��ѯ�ļ��� ����Ŀ¼��Ϣ�͵�ǰĿ¼��Ϣ��ͬ������
            {

                printf("\t\t  %s\t",dir[i].file_name);  //�ļ���
                printf("%d\t",inode_array[k].fileStyle);  //�ļ�������
                printf("%d\t",inode_array[k].fileLength);  //�ļ��ĳ���
                printf("%s\n",dir[i].dir_name);   //�ļ����ڵ�Ŀ¼
            }
        }
    }

    void Ls()         //��ʾ��ǰĿ¼�µ��ļ��б�
    {
        int i,k;
        int flag=0;
        printf("�ļ�����  �ļ�����  �ļ�����  ����Ŀ¼  ������ ������    �޸�ʱ��    \n");
        for(i=0; i<256; i++)
        {
            k=dir[i].inum;
            if((strcmp(cur_dir,dir[i].dir_name)==0))   //��ѯ�ļ��� ����Ŀ¼��Ϣ�͵�ǰĿ¼��Ϣ��ͬ������
            {
                flag=1;
                printf("%s\t",dir[i].file_name);  //�ļ���
                printf("%d\t",inode_array[k].fileStyle);  //�ļ�������
                printf("%d\t",inode_array[k].fileLength);  //�ļ��ĳ���
                printf("%s ",dir[i].dir_name);   //�ļ����ڵ�Ŀ¼
				printf("%d\t",inode_array[k].fileGroup);  //�ļ�������
                printf("%d\n",inode_array[k].fileAssociated);  //�ļ�������
                printf("%s\t",inode_array[k].modifyTime);   //�ļ��޸�ʱ��
                
            }
        }
        if(flag==0)
            printf("it is empty! \n");
    }

    void Cd(void)     //����ָ����Ŀ¼
    {
        int i,k;
        if(argc != 2)
        {
            printf("Command cd must have two args. \n");
            return ;
        }
        if(!strcmp(argv[1], ".."))
        {
            for(i=0; i<256; i++)     //��ѯ�͵�ǰĿ¼����ͬ��Ŀ¼�ļ���
            {
                k=dir[i].inum;
                if(strcmp(cur_dir,dir[i].file_name)==0 && (inode_array[k].fileStyle==0))
                    strcpy(cur_dir,dir[i].dir_name); //����ѯ����Ŀ¼�ļ���  ���ڵ�Ŀ¼��ֵ����ǰĿ¼
            }
            return;
        }

        else
        {
            for(i=0; i<256; i++)
            {
                k=dir[i].inum;      //�ж��ļ������ǲ���Ŀ¼����
                if((strcmp(argv[1],dir[i].file_name)==0) && (inode_array[k].fileStyle==0))
                {
                    strcpy(cur_dir,argv[1]);    //��Ҫ�����ָ��Ŀ¼����Ϊ��ǰĿ¼  ��ֵ��Ҫ����strcpy(Ŀ�ģ�Դ)
                    break;
                }
            }
        }

        if(i==256)
        {
            printf("û�����Ŀ¼\n");
        }
    }


    void Open(void)        //���ļ�
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
                            printf("�ظ��򿪻���ļ���������,��ر�Щ��. \n");
                        }
                    }
                    if (!flag)
                    {
                        for (int x=0; x<8; x++) //����
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
            printf("û������ļ� ��������ļ����������ļ�\n");
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

            time_t t;//����һ��ʱ�����
            t=time(NULL);
            char *time;//����һ���ַ������������ȡ�������ں�ʱ��
            time=ctime(&t);//��ֵ
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
        	printf("�������ݴ���,��������֮��. \n");
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


// ����: �ر��Ѿ��򿪵��ļ�(close file1)
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
        //����Ҫ�޸��ļ������ļ�����
        printf("new name:");
        char Nname[10];
        gets(Nname);
        for(i=0; i<256; i++)     //��Ҫ�������ж�Ҫɾ����Ŀ¼�ǲ��ǵ�ǰĿ¼
        {
            k=dir[i].inum;      //�ҵ�Ŀ¼����
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
        //����Ҫ�޸��ļ�·�� 
        printf("which dir:");
        char Ndir[10];
        gets(Ndir);
        for(i=0; i<256; i++)     //��Ҫ�������ж�Ҫɾ����Ŀ¼�ǲ��ǵ�ǰĿ¼
        {
            k=dir[i].inum;      //�ҵ�Ŀ¼����
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
        //����Ҫ�޸��ļ�ģʽ���ļ�����
        printf("new mod(1 read,2 write,3 exe):");
        int Nmod;
        scanf("%d", &Nmod);

        for(i=0; i<256; i++)
        {
            k=dir[i].inum;      //�ҵ�Ŀ¼����
            if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
            {
                flag=1;
                if(inode_array[k].fileGroup==user.group)
                {
                    inode_array[k].fileMod=Nmod;
                    printf("OK");
                    time_t t;//����һ��ʱ�����
                    t=time(NULL);
                    char *time;//����һ���ַ������������ȡ�������ں�ʱ��
                    time=ctime(&t);//��ֵ
                    inode_array[k].modifyTime=time;
                }
            }
        }
        if(flag==0)
            printf("the file not exist!");
    }

    void Chown(void)
    {
        //����Ҫ�޸��ļ������ߵ��ļ�����
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
// �Ѿ����ڵ��û�, ��������ȷ
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
            k=dir[i].inum;      //�ҵ�Ŀ¼����
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
            //����Ҫ�޸��ļ���������ļ�����
            printf("new group:");
            int Ngroup;
            scanf("%d", &Ngroup);

            for(i=0; i<256; i++)
            {
                k=dir[i].inum;      //�ҵ�Ŀ¼����
                if( strcmp(dir[i].file_name,argv[1])==0 && strcmp(cur_dir,dir[i].file_name)!=0)
                {
                    flag=1;
                    if(inode_array[k].fileGroup==user.group)
                    {
                        inode_array[k].fileGroup=Ngroup;
                        printf("OK\n");
                        time_t t;//����һ��ʱ�����
                        t=time(NULL);
                        char *time;//����һ���ַ������������ȡ�������ں�ʱ��
                        time=ctime(&t);//��ֵ
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
                    printf("�ļ��Ѿ����ڣ����������������ļ�\n");
                    return;
                }
            }

            for(i=0; i<256; i++)
            {
                if(dir[i].inum==-1)
                {
                    dir[i].inum=i;
                    strcpy(dir[i].file_name,fileName);
                    strcpy(dir[i].dir_name,cur_dir);  //�ѵ�ǰĿ¼�� ���½������ļ�
                    int k =dir[i].inum;
                    inode_array[k].fileStyle=inode_array[inum].fileStyle;
                    inode_array[k].fileLength=inode_array[inum].fileLength;
                    strcpy(inode_array[k].fileOwner,inode_array[inum].fileOwner);
                    inode_array[k].fileGroup=inode_array[inum].fileGroup;
                    inode_array[k].fileMod=inode_array[inum].fileMod;
                    time_t t;//����һ��ʱ�����
                    t=time(NULL);
                    char *time;//����һ���ַ������������ȡ�������ں�ʱ��
                    time=ctime(&t);//��ֵ
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
                    printf("�ļ��Ѿ����ڣ����������������ļ�\n");
                    return;
                }
            }

            for(i=0; i<256; i++)
            {
                if(dir[i].inum==-1)
                {
                    dir[i].inum=i;
                    strcpy(dir[i].file_name,fileName);
                    strcpy(dir[i].dir_name,cur_dir);  //�ѵ�ǰĿ¼�� ���½������ļ�
                    int k =dir[i].inum;
                    inode_array[k].fileStyle=inode_array[num].fileStyle;
                    inode_array[k].fileLength=inode_array[num].fileLength;
                    strcpy(inode_array[k].fileOwner,inode_array[num].fileOwner);
                    inode_array[k].fileGroup=inode_array[num].fileGroup;
                    inode_array[k].fileMod=inode_array[num].fileMod;
                    inode_array[num].fileAssociated++;
                    inode_array[k].fileAssociated=inode_array[num].fileAssociated;
                    time_t t;//����һ��ʱ�����
                    t=time(NULL);
                    char *time;//����һ���ַ������������ȡ�������ں�ʱ��
                    time=ctime(&t);//��ֵ
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


// ����: �˳���ǰ�û�(logout)
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
		help		   	  ����   \n\
		Clear		  	  ���� \n\
		Mkdir		  	  ����Ŀ¼   \n\
		Mkfile			  �����ļ� \n\
		Open		   	  ���ļ� \n\
		Read		   	  ���ļ� \n\
		Write		  	  д�ļ� \n\
		Close		  	  �ر��ļ� \n\
		Format		 	  ��ʽ�� \n\
		Logout		 	  ע�� \n\
		Move			  �ƶ� \n\
		Ls				  ��ʾ�ļ�Ŀ¼\n\
		Chmod			  �ı��ļ�Ȩ�� \n\
		Chown  	 		  �ı��ļ�ӵ����\n\
		Chgrp			  �ı��ļ�������\n\
		Pwd				  ��ʾ��ǰĿ¼\n\
		Cd				  �ı䵱ǰĿ¼\n\
		Rmdir			  ɾ��Ŀ¼\n\
		Rmfile			  ɾ���ļ�\n\
		Umask			  �ļ�����������\n\
		Rename			  �ı��ļ���\n\
		Cp				  �ļ�����\n\
		Rmfile			  �ļ�ɾ��\n\
		Ln           	  �����ļ�����\n\
		Cat				  ������ʾ�ļ�����\n\
		Passwd			  �޸��û�����\n\
		Quit    		  �����˳�\n");
        }



        void command(void)
        {
            char cmd[100];
            style=0;         //0�����ļ�������Ŀ¼�ļ�
        	Mkfile("dev",0);
        	Mkfile("user",0);
        	Mkfile("etc",0);
        	style=1;         //����ָ���ֵ����Ϊȫ�ֱ���������
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
