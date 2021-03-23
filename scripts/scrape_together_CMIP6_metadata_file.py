from netCDF4 import Dataset
import urllib
import glob
import json
import pandas as pd

fnames=glob.glob("../netcdfs/annClim/tas_annClim*nc")
print(fnames)
numncfiles=len(fnames)

for i in range(0,numncfiles):
  file = fnames[i]
  
  #Step 1 load the netcdf file and get the values of several global attributes
  r = Dataset(file, mode='r')
  mip_era = getattr(r,'mip_era')
  pid = getattr(r,'tracking_id')
  activity_id = getattr(r,'activity_id')
  institution_id = getattr(r,'institution_id')
  source_id = getattr(r,'source_id')
  experiment_id = getattr(r,'experiment_id')
  sub_experiment_id = getattr(r,'sub_experiment_id')
  table_id = getattr(r,'table_id')
  variable_id = getattr(r,'variable_id')
  variant_label = getattr(r,'variant_label')
  grid_label = getattr(r,'grid_label')
  r.close()
  
  data_ref_syntax = mip_era+'.'+activity_id+'.'+institution_id+'.'+source_id+'.'+experiment_id
  
  #Remove 'hdl:' from the start of the pid
  if pid[0:4] == 'hdl:':
    pid = pid[4:]
  
  #Go to the webpage for the PID
  
  pidurl = 'https://handle-esgf.dkrz.de/lp/handles/'+pid
  
  readurl = urllib.request.urlopen(pidurl)
  data = json.loads(readurl.read())
  
  try:
    version_number = data["VERSION_NUMBER"]
  except KeyError:
    datasetpid = data["URL_ORIGINAL_DATA"][0]["dataset"]
    if datasetpid[0:4] == 'hdl:':
      datasetpid = datasetpid[4:]

    datasetpidurl = 'https://handle-esgf.dkrz.de/lp/handles/'+datasetpid
      
    readurl_dataset = urllib.request.urlopen(datasetpidurl)
    data_dataset = json.loads(readurl_dataset.read())
    version_number = data_dataset["VERSION_NUMBER"]

  if i == 0:
    data = {'DATA_REF_SYNTAX': [data_ref_syntax],
            'SUB_EX_ID': ['none'],
            'ENS_MEMBER': [variant_label],
            'TABLE_ID': [table_id],
            'VAR_NAME': [variable_id],
            'GRID_LABEL':[grid_label],
            'VERSION_NO':[version_number],
            'HANDLE':['hdl:'+pid],
            'SUBPANEL':['b']}
    df=pd.DataFrame(data,columns=['DATA_REF_SYNTAX','SUB_EX_ID','ENS_MEMBER','TABLE_ID','VAR_NAME','GRID_LABEL','VERSION_NO','HANDLE','SUBPANEL'])
  else:
    df2=pd.DataFrame(data,columns=['DATA_REF_SYNTAX','SUB_EX_ID','ENS_MEMBER','TABLE_ID','VAR_NAME','GRID_LABEL','VERSION_NO','HANDLE','SUBPANEL'])
    df.append(df2,ignore_index=True)
  
#df.to_csv('fig3.2b_md_cmip6.csv')
