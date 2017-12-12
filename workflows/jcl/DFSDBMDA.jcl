//IMSDALOC PROC
//ASSEM  EXEC PGM=ASMA90,
//            PARM='ALIGN,DECK,NOOBJECT,NODBCS'
//SYSLIB   DD DSN=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.ADFSMAC,DISP=SHR
//         DD DSN=${instance-zCloud_MACLIB},DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(10,5))
//*
//SYSPUNCH DD DSN=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.${instance-DFS_AUTH_USER_HLQ3}.OBJMOD,
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=400),
//         SPACE=(400,(100,100)),UNIT=SYSDA,
//         DISP=(NEW,PASS)
//SYSPRINT DD SYSOUT=*
//BLDMBR EXEC PGM=IEBUPDTE,PARM='NEW',
//            COND=(7,LT,ASSEM)
//SYSPRINT DD DUMMY
//SYSUT2   DD DSN=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.${instance-DFS_AUTH_USER_HLQ3}.TEMPPDS,UNIT=SYSDA,
//         DISP=(NEW,PASS,DELETE),
//         SPACE=(80,(1000,500,10)),
//         DCB=(RECFM=F,BLKSIZE=80)
//SYSIN    DD DSN=*.ASSEM.SYSPUNCH,
//         DISP=(OLD,DELETE,DELETE)
//LNKEDT EXEC PGM=IEWL,PARM='LIST,XREF,LET',
//            COND=((7,LT,ASSEM),(3,LT,BLDMBR))
//SYSUT1   DD UNIT=SYSDA,SPACE=(1024,(100,50))
//SYSLIB   DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSLMOD  DD DSN=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.SDFSRESL,DISP=SHR
//OBJMOD   DD DSN=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.${instance-DFS_AUTH_USER_HLQ3}.TEMPPDS,
//         DISP=(OLD,DELETE,DELETE)
//SYSLIN   DD DSN=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.${instance-DFS_AUTH_USER_HLQ3}.TEMPPDS(LNKCTL),
//         DISP=(OLD,DELETE,DELETE),
//         VOL=REF=*.OBJMOD
//         PEND
//STEP01   EXEC PROC=IMSDALOC
//ASSEM.SYSIN DD *
*
* START
*
  DFSMDA TYPE=INITIAL
*
* DATA BASE  ${instance-DBname}
*
* HDAM/OSAM
*
  DFSMDA TYPE=DATABASE,DBNAME=${instance-DBname}
  DFSMDA TYPE=DATASET,                                                 X
#formatLine("               DDNAME=${instance-AREAname},",71,16,false,"X")
#formatLine("               DSNAME=${instance-DFS_AUTH_LIB_HLQ}.${instance-DFS_AUTH_LIB_HLQ2}.${instance-DFS_AUTH_USER_HLQ3}.${instance-DBname}.${instance-AREAname},DISP=SHR",71,16,true,"X")
  DFSMDA TYPE=FINAL
          END
/*
//*
## ******************************************************************
## Velocity macro to format a line and ensure that the JCL continuation
## character appears in Column 72.
## Note: This macro has been provided by the z/OSMF development team.
## ******************************************************************
#macro(formatLine $line $len $indent $isLastLine $suffix)
#if($line.length() <= $len)
#if($isLastLine)
$line.format("%-${len}s", $line)
#else
$line.format("%-${len}s", $line)$!{suffix}
#end
#else
#makeIndent("$line", $len, $indent, $isLastLine "$!{suffix}")
#end
#end
## ******************************************************************
## Velocity macro to handle indentation if JCL statement does not fit
## in 71 chars.
## Note: This macro has been supplied by the z/OSMF development team.
## ******************************************************************
#macro(makeIndent $line $len $indent $isLastLine $suffix)
$line.substring(0, ${len})$suffix
#set ($left = $line.substring(${len}))
#set ($size = $indent + $left.length())
#set ($left = $left.format("%${size}s", $left))
#if($left.length() <= $len)
#if($isLastLine)
$line.format("%-${len}s", $left)
#else
$line.format("%-${len}s", $left)$suffix
#end
#else
#makeIndent("$left", $len, $indent, $isLastLine, "$suffix")
#end
#end