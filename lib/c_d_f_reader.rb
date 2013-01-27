class CDFReader
  def self.read(plant, i, j)
    cdf = NumRu::NetCDF.open(plant.file)
    num = cdf.var(plant.code)[i, j, 0, 0][0]
    cdf.close()
  end
end
