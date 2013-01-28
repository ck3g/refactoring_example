require './lib/biome.rb'

class WorkflowsController

  def get_biome
    @biome_data = Biome.data Coordinates.new(params[:lat].to_i, params[:lng].to_i)
    respond_to do |format|
      format.json { render json: @biome_data }
    end
  end
end
