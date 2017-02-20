#!/bin/bash
if [ -$1- = -- ] ; then echo  device not specified; exit; fi 
echo  Drive $1 needs to be in a Inactive state 
echo  if you haven\'t already done so please do a revertnoerase/reverttper or 
echo  PSID revert on $1
echo  -
echo  Continuing with this test suite WILL ERASE ALL DATA ON $1
echo  If you dont want that to happen hit Ctrl-C now.
echo  press enter to continue or Ctrl-c to abort
read INOUT
echo  Last chance to hit Ctrl-c an keep the data on your drive
read INPUT
## test PROG commands
PROG=CLI/Win32/Release/sedutil-cli.exe
##PROG=CLI/x64/Release/sedutil-cli.exe
##PROG=./sedutil-cli.exe
##PROG=echo 
LOGFILE=sedutil_baseline
OUTPUTSINK=">>  ${LOGFILE} 2>&1"
echo  testing sedutil `date` > ${LOGFILE}

##
echo  Begin TestSuite.cmd > ${LOGFILE}
uname -a >> ${LOGFILE}
echo testing PROG `date` | tee -a ${LOGFILE} 
${PROG} --help | grep -a Copyright >>  ${LOGFILE} 2>&1

${PROG} --scan >>  ${LOGFILE} 2>&1
echo Perform the initial setup | tee -a ${LOGFILE}
${PROG} --initialsetup passw0rd $1 >>  ${LOGFILE} 2>&1
${PROG} --query $1 | grep -a MediaEncrypt >>  ${LOGFILE} 2>&1
echo change the LSP Admin1 password | tee -a ${LOGFILE}
${PROG} --setAdmin1Pwd passw0rd password $1 >>  ${LOGFILE} 2>&1
${PROG} --enableLockingRange 0 password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo test readlocking | tee -a ${LOGFILE}
${PROG}  --setLockingRange 0 RO password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo test write locking | tee -a ${LOGFILE}
${PROG} --setLockingRange 0 RW password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo set LockingRange 0 LK | tee -a ${LOGFILE}
${PROG} --setLockingRange 0 lk password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo disable locking on the global range | tee -a ${LOGFILE}
${PROG} --disableLockingRange 0 password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo test locking on lockingrange1 | tee -a ${LOGFILE}
${PROG} --setupLockingRange 1 0 2048 password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo Readonly locking on lockingrange1 | tee -a ${LOGFILE}
${PROG} --readonlyLockingRange 1 password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo enable locking on lockingrange 1 | tee -a ${LOGFILE}
${PROG} --enableLockingRange 1 password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo RO locking on lockingrange 1 | tee -a ${LOGFILE}
${PROG} --setLockingRange 1 RO password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo RW locking on lockingrange 1 | tee -a ${LOGFILE}
${PROG} --setLockingRange 1 RW password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo LK locking on lockingrange 1 | tee -a ${LOGFILE}
${PROG} --setLockingRange 1 LK password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| head -5 >>  ${LOGFILE} 2>&1
echo test locking on lockingrange15 | tee -a ${LOGFILE}
${PROG} --setupLockingRange 15 2048 204800 password $1 >>  ${LOGFILE} 2>&1
${PROG} --listLockingRanges password $1 2>&1| tail -4 >>  ${LOGFILE} 2>&1
echo unset MBRDone | tee -a ${LOGFILE}
${PROG} --setMBRDone OFF password $1 >>  ${LOGFILE} 2>&1
${PROG} --query $1 | grep -a MediaEncrypt >>  ${LOGFILE} 2>&1
echo disable mbr shadowing | tee -a ${LOGFILE}
${PROG} --setMBREnable off password $1 >>  ${LOGFILE} 2>&1
${PROG} --query $1 | grep -a MediaEncrypt >>  ${LOGFILE} 2>&1
echo resetting device | tee -a ${LOGFILE}
${PROG} --revertnoerase password $1 >>  ${LOGFILE} 2>&1
${PROG} --query $1 | grep -a MediaEncrypt >>  ${LOGFILE} 2>&1
${PROG} --reverttper passw0rd $1 >>  ${LOGFILE} 2>&1
${PROG} --query $1 | grep -a MediaEncrypt >>  ${LOGFILE} 2>&1
${PROG} --validatePBKDF2 >>  ${LOGFILE} 2>&1
echo  Thanks for running the test suite 
echo  please e-mail ${LOGFILE} to r0m30@drivetrust.com
echo  along with the OS, OS level and type of drive you have
exit