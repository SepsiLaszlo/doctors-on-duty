class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ check_in check_out show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: %i[ check_in check_out check_in_all]

  rescue_from StandardError do |exception|
    redirect_to doctors_path, notice: exception.message
  end

  def check_in
    @doctor.check_in!

    respond_to do |format|
      format.html { redirect_to doctors_path }
      format.json {  render plain: 'ok', status: :ok }
    end
  end

  def check_out
    @doctor.check_out!

    respond_to do |format|
      format.html { redirect_to doctors_path }
      format.json {  render plain: 'ok', status: :ok }
    end
  end

  def check_in_all
    Doctor.update_all(on_duty: true)

    render plain: 'ok', status: :ok
  end

  def on_duty
    render plain: Doctor.on_duty.count, status: :ok
  end

  # GET /doctors or /doctors.json
  def index
    @doctors = Doctor.all.order(:id)
  end

  # GET /doctors/1 or /doctors/1.json
  def show
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  # GET /doctors/1/edit
  def edit
  end

  # POST /doctors or /doctors.json
  def create
    @doctor = Doctor.new(doctor_params)

    respond_to do |format|
      if @doctor.save
        format.html { redirect_to doctor_url(@doctor), notice: "Doctor was successfully created." }
        format.json { render :show, status: :created, location: @doctor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doctors/1 or /doctors/1.json
  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to doctor_url(@doctor), notice: "Doctor was successfully updated." }
        format.json { render :show, status: :ok, location: @doctor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doctors/1 or /doctors/1.json
  def destroy
    @doctor.destroy!

    respond_to do |format|
      format.html { redirect_to doctors_url, notice: "Doctor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def doctor_params
      params.require(:doctor).permit(:name, :on_duty)
    end
end
