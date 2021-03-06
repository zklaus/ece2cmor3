#!/bin/bash
#
# This script can not be executed, because a few manual editting steps are required.
#
# Run example:
#  ./update-basic-identifiedmissing-ignored-files.sh
#

if [ "$#" -eq -2 ]; then

# Procedure to produce the list-of-identified-missing-cmpi6-requested-variables.xlsx based on the most updated shaconemo ping files.
# In this way the variable and table can be provided in the list-of-identified-missing-cmpi6-requested-variables.xlsx while at the
# other hand shaconemo updates can be relatively easy followed by copying the entire variable column. In order to catch all provided
# (non dummy) variables from the shaconemo ping files, we use the total CMIP6 request for all CMIP6 MIPs with highest tier and priority.

# Step 1: request all CMIP6 MIPs for most extended tier and priority:
  cd ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/; 
  drq -m CMIP,AerChemMIP,C4MIP,CFMIP,DAMIP,DCPP,FAFMIP,GeoMIP,GMMIP,HighResMIP,ISMIP6,LS3MIP,LUMIP,OMIP,PMIP,RFMIP,ScenarioMIP,VolMIP,CORDEX,DynVar,SIMIP,VIACSAB -t 3 -p 3 -e CMIP  --xls --xlsDir xls-all-cmip6-t=3-p=3

# Step 2: update the Shaconemo repository and thus the ping files:
  cd ${HOME}/cmorize/shaconemo/ping-files/
  ./extract-info-from-ping-files.csh

# Step 3: Manually select the total column of variables in this file:
  nedit r211/cmor-varlist-based-on-ping-r211-without-dummy-lines.txt
# and copy them manually into the variable column in the file (also update the comment column):
  xdg-open ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/pre-list-of-identified-missing-cmpi6-requested-variables.xlsx
# After updating the pre* files it is handiest to commit them first.

# Step 4: Temporary overwrite the basic identifiedmissing and basic ignored files by their corresponding pre-* ones:
  cpf ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/pre-list-of-identified-missing-cmpi6-requested-variables.xlsx             ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/list-of-identified-missing-cmpi6-requested-variables.xlsx
  cpf ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/pre-list-of-ignored-cmpi6-requested-variables.xlsx                        ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/list-of-ignored-cmpi6-requested-variables.xlsx
# Alternatively, for the latter one the pre basic ignored can be taken which contains all the dummy ping file variables:
  cpf ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/pre-list-of-ignored-cmpi6-requested-variables-including-ping-dummies.xlsx ${HOME}/cmorize/ece2cmor3/ece2cmor3/resources/list-of-ignored-cmpi6-requested-variables.xlsx

# Step 5: Run with the --withouttablescheck option checkvars.py based on the largest data request (and the pre-list-*.xlsx):
   cd ${HOME}/cmorize/ece2cmor3/; python setup.py install; cd -;
   cd ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts;
   ./checkvars.py --withouttablescheck -v --vars  xls-all-cmip6-t=3-p=3/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.vo_TOTAL_3_3.xlsx  --output cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.vo_TOTAL_3_3
#  xdg-open cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.identifiedmissing.xlsx

# Step 6: Copy the resulting identifiedmissing and ignored produced by the checkvars.py to the basic identifiedmissing and the basic ignored:
   cpf cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.identifiedmissing.xlsx ../resources/list-of-identified-missing-cmpi6-requested-variables.xlsx
   cpf cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.ignored.xlsx           ../resources/list-of-ignored-cmpi6-requested-variables.xlsx


# Test that this replace gives still the same results:
   mkdir -p ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi; rm -f ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.*;
   cp ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.* ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi/;
   cd ${HOME}/cmorize/ece2cmor3/; python setup.py install; cd -;
   cd ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts;
   ./checkvars.py -v --vars  xls-all-cmip6-t=3-p=3/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.vo_TOTAL_3_3.xlsx  --output cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.vo_TOTAL_3_3
# The diff is not identical but the excel-diff gives no cel differences:
   diff       ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.identifiedmissing.txt  ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.identifiedmissing.txt
   diff       ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.ignored.txt            ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.ignored.txt
#  excel-diff ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.identifiedmissing.xlsx ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.identifiedmissing.xlsx
#  excel-diff ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.ignored.xlsx           ${HOME}/cmorize/ece2cmor3/ece2cmor3/scripts/tmp-backup-cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi/cmvmm_ae.c4.cf.cm.co.da.dc.dy.fa.ge.gm.hi.is.ls.lu.om.pm.rf.sc.si.vi.ignored.xlsx

# Note exel-diff is installed by following:
#   https://github.com/na-ka-na/ExcelCompare/blob/master/README.md
# Extract the zip and 
#  mv Downloads/ExcelCompare-0.6.1 ${HOME}/bin; cd ${HOME}/bin/; ln -s ExcelCompare-0.6.1/bin/excel_cmp excel-diff;


else
    echo '  '
    echo '  This script can not be executed, because a few manual editting steps are required.'
    echo '  This guidence servers to produce the basic identifiedmissing file and the basic ignored file.'
    echo '  '
fi
