class WorkflowsController

  def remap_range(input, in_low, in_high, out_low, out_high)
    # map onto [0,1] using input range
    frac = ( input - in_low ) / ( in_high - in_low )
    # map onto output range
    ( frac * ( out_high - out_low ) + out_low ).to_i.round()
  end

  def get_biome
    @lng = params[:lng].to_i
    @lat = params[:lat].to_i

    ## US SpringWheat
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (24.75 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    # http://localhost:3000/get_biome.json?lng=-97.25&lat=44.75 # => 0.0956562
    if ( 49.75 >= @lat && @lat >= 24.75 && -65.25 >= @lng && @lng >= -105.25 )
      @us_springwheat_i = remap_range( @lng, -105.25, -65.25, 0, 80 )
      @us_springwheat_j = remap_range( @lat, 49.75, 24.75, 0, 50 ) # i == 0 where lat is at its lowest value
      @us_springwheat = NumRu::NetCDF.open("netcdf/GCS/Crops/US/SpringWheat/fractioncover/fswh_2.7_us.0.5deg.nc")
      @us_springwheat_num = @us_springwheat.var("fswh")[@us_springwheat_i,@us_springwheat_j,0,0][0]
#      @us_springwheat_num = @us_springwheat.var("fswh")[12,7,0,0][0] #=>> 0.21387700736522675
      @us_springwheat.close()
    end

    ## US Soybean
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (24.75 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    if ( 49.75 >= @lat && @lat >= 24.75 && -65.25 >= @lng && @lng >= -105.25 )
      @us_soybean_i = remap_range( @lng, -105.25, -65.25, 0, 80 )
      @us_soybean_j = remap_range( @lat, 49.75, 24.75, 0, 50 ) # i == 0 where lat is at its lowest value
      @us_soybean = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Soybean/fractioncover/fsoy_2.7_us.0.5deg.nc")
      @us_soybean_num = @us_soybean.var("fsoy")[@us_soybean_i,@us_soybean_j,0,0][0]
#      @us_soybean_num = @us_soybean.var("fsoy")[22,13,0,0][0] #=>> 0.40256670117378235
      @us_soybean.close()
    end

    ## US Corn
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (25.25 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    # http://localhost:3000/get_biome?lng=-83.25&lat=44.25 # => 0.18501955270767212
    if ( 49.75 >= @lat && @lat >= 24.75 && -65.25 >= @lng && @lng >= -105.25 )
      @us_corn_i = remap_range( @lng, -105.25, -65.25, 0, 80 )
      @us_corn_j = remap_range( @lat, 49.75, 25.25, 0, 50 ) # j == 0 where lat is at its lowest value
      @us_corn = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Corn/fractioncover/fcorn_2.7_us.0.5deg.nc")
      @us_corn_num = @us_corn.var("fcorn")[@us_corn_i,@us_corn_j,0,0][0]
      @us_corn.close()
    end

    ## Brazil Sugarcane
    # This map has an ij coordinate range of (0,0) to (59, 44)
    # top left LatLng being (-60.25 ,-4.75)
    # bottom right LatLng being (-30.75 ,-26.75)
    # Therefore it sits between:
    # Lat -4.75 and -26.75
    # Lon -30.75 and -60.25
    if ( -4.75 >= @lat && @lat >= -26.75 && -30.75 >= @lng && @lng >= -60.25 )
      @braz_sugarcane_i = remap_range( @lng, -30.75, -60.25, 0, 59 )
      @braz_sugarcane_j = remap_range( @lat, -4.75, -26.75, 0, 44 ) # i == 0 where lat is at its lowest value
      @braz_sugarcane = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Sugarcane/brazil_sugc_latent_10yr_avg.nc")
      @braz_sugarcane_num = @braz_sugarcane.var("latent")[@braz_sugarcane_i,@braz_sugarcane_j,0,0][0]
      @braz_sugarcane.close()
    end

    ## Vegtype
    # This map has an ij coordinate range of (0,0) to (720, 360)
    # top left LatLng being (89.75, -179.25)
    # top left LatLng being (-89.75, 179.25)
    # Therefore it sits between:
    # Lat -89.75 and 89.75
    # Lon -179.25 and 179.25
    @vegtype_i = remap_range( @lng.to_i , -179.25, 179.25, 0, 720 )
    @vegtype_j = remap_range( @lat.to_i , 89.75, -89.75, 0, 360 ) # i == 0 where lat is at its lowest value
    @vegtype = NumRu::NetCDF.open("netcdf/vegtype.nc")
    @biome_num = @vegtype.var("vegtype")[@vegtype_i,@vegtype_j,0,0][0]
    @vegtype.close()

    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p @ecosystems[0] # will return a Hash
    # p @ecosystems[0]["category"] # => "native"
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/data/default_ecosystems.json" , "r" ).read )

    @biome_data = {}
    if @biome_num <= 15
      @biome_data["native"] = @ecosystems[@biome_num]
    end

    @biofuel_names = []
    @agroecosystem_names = []
    ############ Here we set the threshold levels ############
    if @us_springwheat_num != nil #&& @us_springwheat_num > 0.01
      @agroecosystem_names << "spring wheat"
    end
    # should include spring wheat in the JSON:
    # http://localhost:3000/get_biome.json?lng=-97.25&lat=44.75

    if @us_soybean_num != nil && @us_soybean_num < 0.01
      @biofuel_names << "soybean"
    end
    # should include soybean in the JSON:

    # should NOT include soybean in the JSON:


    if @us_corn_num != nil && @us_corn_num > 0.01
      @biofuel_names << "corn"
    end
    # should include corn in the JSON:
    # http://localhost:3000/get_biome.json?lng=-95.25&lat=44.25
    # should NOT include corn in the JSON:
    # http://localhost:3000/get_biome.json?lng=-71.25&lat=33.75

    if @braz_sugarcane_num != nil && @braz_sugarcane_num < 110
      @biofuel_names << "brazil sugarcane"
    end

#    @biome_data["biofuels"] = { "name"=> @biofuel_names.join(",") }
    @biome_data["biofuels"]       = { "name"=> @biofuel_names.join(",") }
    @biome_data["agroecosystems"] = { "name"=> @agroecosystem_names.join(",") }

    # respond_to do |format|
    #   format.json { render json: @biome_data }
    # end

  end
end
