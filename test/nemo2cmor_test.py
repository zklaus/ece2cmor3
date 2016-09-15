import logging
import unittest
import os
import numpy
import math
import datetime
import nose.tools
import nemo2cmor
import test_utils
import cmor_source

logging.basicConfig(level=logging.DEBUG)

def circwave(t,i,j):
    return 15*math.cos((i*i+j*j)/10000.0 + t/2.)

def hypwave(t,i,j):
    return 0.001*math.cos((i*i-j*j)/10000.0 + t/2.)

class nemo2cmor_tests(unittest.TestCase):

    def datapath(self):
        return os.path.join(os.path.dirname(__file__),"test_data","nemodata")

    def setUp(self):

        dimx=40
        dimy=50
        dirname=self.datapath()
        os.mkdir(dirname)

        opf=test_utils.nemo_output_factory()

        opf.make_grid(dimx,dimy,cmor_source.nemo_grid.grid_U)
        opf.set_timeframe(datetime.date(1990,1,1),datetime.date(1991,1,1),"1d")
        uto={"name":"uto",
             "function":circwave,
             "standard_name":"temperature_transport_x",
             "long_name":"Product of x-ward sea water velocity and temperature",
             "units":"m degC s-1"}
        uso={"name":"uso",
             "function":hypwave,
             "standard_name":"salinity_transport_x",
             "long_name":"Product of x-ward sea water velocity and salinity",
             "units":"kg m-2 s-1"}
        opf.write_variables(dirname,"exp",[uto,uso])

        opf.make_grid(dimx,dimy,cmor_source.nemo_grid.grid_V)
        opf.set_timeframe(datetime.date(1990,1,1),datetime.date(1991,1,1),"1d")
        vto={"name":"vto",
             "function":circwave,
             "standard_name":"temperature_transport_y",
             "long_name":"Product of y-ward sea water velocity and temperature",
             "units":"m degC s-1"}
        vso={"name":"vso",
             "function":hypwave,
             "standard_name":"salinity_transport_y",
             "long_name":"Product of y-ward sea water velocity and salinity",
             "units":"kg m-2 s-1"}
        opf.write_variables(dirname,"exp",[vto,vso])

        opf.make_grid(dimx,dimy,cmor_source.nemo_grid.grid_T)
        opf.set_timeframe(datetime.date(1990,1,1),datetime.date(1991,1,1),"1m")
        tos={"name":"tos","function":circwave,"standard_name":"sea_surface_temperature","long_name":"Sea surface temperature","units":"degC"}
        sos={"name":"sos","function":hypwave,"standard_name":"sea_surface_salinity","long_name":"Sea surface salinity","units":"kg m-3"}
        opf.write_variables(dirname,"exp",[tos,sos])

        opf.make_grid(dimx,dimy,cmor_source.nemo_grid.icemod)
        opf.set_timeframe(datetime.date(1990,1,1),datetime.date(1991,1,1),"6h")
        sit={"name":"sit","function":circwave,"standard_name":"sea_ice_temperature","long_name":"Sea ice temperature","units":"degC"}
        opf.write_variables(dirname,"exp",[sit])

    def tearDown(self):
        dirname=self.datapath()
        for f in os.listdir(dirname):
            os.remove(os.path.join(dirname,f))
        os.rmdir(dirname)

    def test_create_grid(self):
        dim=1000
        lons=numpy.zeros([dim,dim],dtype=numpy.float64)
        lons=numpy.fromfunction(lambda i,j:(i*360+0.5)/(0.5*(dim+j)+2),(dim,dim),dtype=numpy.float64)
        lats=numpy.fromfunction(lambda i,j:(j*180+0.5)/(0.5*(dim+i)+2)-90,(dim,dim),dtype=numpy.float64)

        grid=nemo2cmor.nemogrid(lons,lats)

        p1=(grid.vertex_lons[0,0,0],grid.vertex_lats[0,0,0])
        p2=(grid.vertex_lons[1,0,0],grid.vertex_lats[1,0,0])
        p3=(grid.vertex_lons[2,0,0],grid.vertex_lats[2,0,0])
        p4=(grid.vertex_lons[3,0,0],grid.vertex_lats[3,0,0])

        nose.tools.eq_(p1[0],p4[0])
        nose.tools.eq_(p2[0],p3[0])
        nose.tools.eq_(p1[1],p2[1])
        nose.tools.eq_(p3[1],p4[1])

    def test_init_nemo2cmor(self):
        dirname=self.datapath()
        tabroot=os.path.abspath(os.path.dirname(nemo2cmor.__file__)+"/../../input/cmip6/cmip6-cmor-tables/Tables/CMIP6")
        nemo2cmor.initialize(dirname,"exp",tabroot,datetime.datetime(1990,3,1),datetime.timedelta(days=100))