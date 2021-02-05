; These scripts aim to:
;   1. Create monthly climatologies of each cal-adj simulation (this script)
;   2. Compute differences in these climatologies from the piControl climatology
;   3. Regrid each climate difference onto a 1x1 grid
;   4. Combine into an ensemble file

; Required metadata to be taken from each file:
;   tracking_id of piControl file
;   tracking_id of expt file
;   name of model
;   X resolution of model
;   Y resolution of model

; This particular script does only step one...

DATA_DIR="/data/CMIP/curated_ESGF_replica"
monClim_DIR="../netcdfs/monClim"
annClim_DIR="../netcdfs/annClim"
OVERWRITE_EXISTING=False

; Start by creating climatologies on the native grids...
expt_names=(/"lgm-cal-adj","piControl","lig127k-cal-adj","midHolocene-cal-adj","midPliocene-eoi400"/)
var_names=(/"tas","pr"/)

do expt_i = 0,dimsizes(expt_names)-1
  ; determine relevant directories
  dirs=systemfunc("ls -d -IAWI-ESM-old -IHadGEM3-GC31-interimfiles /data/CMIP/curated_ESGF_replica/*/"+expt_names(expt_i))
  gcm_names=dirs ;set up a holding array of the write size/type
  climo_names=dirs
  ; identify model names
  do gcm_i=0,dimsizes(gcm_names)-1
    str_frags=str_split(dirs(gcm_i),"/")
    gcm_names(gcm_i)=str_frags(3)
    delete(str_frags)
  end do
  ; create monthly climatology
  do gcm_i=0,dimsizes(gcm_names)-1
    do var_i = 0,dimsizes(var_names)-1
      fils=systemfunc("ls "+dirs(gcm_i)+"/"+var_names(var_i)+"_Amon"+"*nc")
      ann_fils=str_sub_str(fils,"-cal-adj","")
      print("Working on "+gcm_names(gcm_i))
      print(" files: "+fils)
      print(" ")
      if .not.all(ismissing(fils)) then
        n_files=dimsizes(fils)
        if n_files.ge.2 then
          str_frags=str_split(fils(0),"/")
          f1=str_frags(5)
          climo_names(gcm_i)=str_sub_str(f1,"Amon","annClim")
          climo_names(gcm_i)=str_sub_str(climo_names(gcm_i),"-cal-adj_","_")
          f1_c=stringtocharacter(f1)
          end_yr_f1=tostring(f1_c(str_index_of_substr(f1,".nc", -1)-6:str_index_of_substr(f1,".nc", -1)-1))
          str_frags=str_split(fils(n_files-1),"/")
          fn_c=stringtocharacter(str_frags(5))
          end_yr_fn=tostring(fn_c(str_index_of_substr(str_frags(5),".nc", -1)-6:str_index_of_substr(str_frags(5),".nc", -1)-1))
          climo_names(gcm_i)=str_sub_str(climo_names(gcm_i),end_yr_f1,end_yr_fn)
          if OVERWRITE_EXISTING.or.(.not.fileexists(annClim_DIR+"/"+climo_names(gcm_i))) then
            system("ncrcat -O "+str_concat(ann_fils+" ")+" "+annClim_DIR+"/"+climo_names(gcm_i)+".all.nc")
            system("ncwa -O -a time "+" "+annClim_DIR+"/"+climo_names(gcm_i)+".all.nc "+annClim_DIR+"/"+climo_names(gcm_i))
            system("rm "+annClim_DIR+"/"+climo_names(gcm_i)+".all.nc")
          end if 
          climo_names(gcm_i)=str_sub_str(climo_names(gcm_i),"annClim","monClim")
          delete(str_frags)
          if OVERWRITE_EXISTING.or.(.not.fileexists(monClim_DIR+"/"+climo_names(gcm_i))) then
            system("ncks -O -d time,0,11 "+fils(0)+" "+monClim_DIR+"/"+climo_names(gcm_i))
            infil=addfiles(fils,"r")
            outfil=addfile(monClim_DIR+"/"+climo_names(gcm_i),"w")
            monthly=infil[:]->$var_names(var_i)$
            monClim=clmMonTLL(monthly)
            outfil->$var_names(var_i)$=(/monClim/)
          delete([/infil,outfil,monthly,monClim/])
          end if
          delete([/f1,f1_c,fn_c,end_yr_f1,end_yr_fn/])
        else  
          str_frags=str_split(fils,"/")
          climo_names(gcm_i)=str_sub_str(str_frags(5),"Amon","annClim")
          climo_names(gcm_i)=str_sub_str(climo_names(gcm_i),"-cal-adj_","_")
          if OVERWRITE_EXISTING.or.(.not.fileexists(annClim_DIR+"/"+climo_names(gcm_i))) then
            system("ncwa -O -a time "+ann_fils+" "+annClim_DIR+"/"+climo_names(gcm_i))
          end if
          climo_names(gcm_i)=str_sub_str(climo_names(gcm_i),"annClim","monClim")
          delete(str_frags)
          if OVERWRITE_EXISTING.or.(.not.fileexists(monClim_DIR+"/"+climo_names(gcm_i))) then
            system("ncks -O -d time,0,11 "+fils+" "+monClim_DIR+"/"+climo_names(gcm_i))
            infil=addfile(fils,"r")
            outfil=addfile(monClim_DIR+"/"+climo_names(gcm_i),"w")
            monthly=infil->$var_names(var_i)$
            monClim=clmMonTLL(monthly)
            outfil->$var_names(var_i)$=(/monClim/)
            delete([/infil,outfil,monthly,monClim/])
          end if
        end if
      end if
      delete([/fils,ann_fils/])
    end do;var_names
  end do;gcms
  delete([/gcm_names,climo_names,dirs/])
end do;expts




;ncecat line
;ncks line to add model name as dimension
