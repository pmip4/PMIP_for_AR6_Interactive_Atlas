from netCDF4 import Dataset
import urllib
import glob
import json

fnames=glob.glob("../netcdfs/annClim/tas_annClim*nc")
numncfiles=len(fnames)

for i in range(0,numncfiles):
  file = fnames[i]
  
  #Step 1 load the netcdf file and get the values of several global attributes
  r = Dataset(file, mode='r')
  pid = getattr(r,'tracking_id')
  mip_era = getattr(r,'mip_era')
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

  csv_string=data_ref_syntax
  print(
