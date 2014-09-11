#!/bin/sh
# Uso backup_vm.sh <nomedavm>

VAR1=$1
BKPDIR=/backup
VMNAME=`./list_vm.sh |grep $VAR1 | awk '{print $1}'`
UUID=`./list_vm.sh |grep $VAR1 | awk '{print $5}'`

if [ -z "$VMNAME" ]; then
	echo "VM nao encontrada"
	exit 0
fi

echo -n Gerando Snapshot para VM $VMNAME
SNAP_UUID=`xe vm-snapshot vm=$UUID new-name-label=Backup-$VMNAME`
echo UUID: $SNAP_UUID
xe template-param-set is-a-template=false  uuid=$SNAP_UUID
echo Gerando backup...
if [ -f $BKPDIR/Backup-$VMNAME.xva.old ]; then
	rm -f $BKPDIR/Backup-$VMNAME.xva.old
	mv $BKPDIR/Backup-$VMNAME.xva $BKPDIR/Backup-$VMNAME.xva.old
else
	mv $BKPDIR/Backup-$VMNAME.xva $BKPDIR/Backup-$VMNAME.xva.old
fi
time xe vm-export uuid=$SNAP_UUID filename=$BKPDIR/Backup-$VMNAME.xva
echo Removendo snapshot...
xe vm-uninstall uuid=$SNAP_UUID force=true
echo Terminado.

