class ReservationsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show, :new, :create ]
  before_action :set_reservation, only: %i[ show edit update destroy ]

  # GET /reservations or /reservations.json
  def index
    @tab = params[:tab] || (current_user ? "ativas" : "sugestoes")

    if current_user
      all_reservations = Reservation.where(
        "user_id = ? OR (user_id IS NULL AND email = ?)",
        current_user.id, current_user.email_address
      )

      case @tab
      when "ativas"
        @reservations = all_reservations.joins(:establishment)
                                        .where("date >= ? AND status IN (?)",
                                               Time.current, [ "confirmed", "pending" ])
                                        .includes(:establishment)
                                        .order(date: :asc)
      when "historico"
        @reservations = all_reservations.joins(:establishment)
                                        .where("date < ? OR status = ?",
                                               Time.current, "completed")
                                        .includes(:establishment)
                                        .order(date: :desc)
      when "sugestoes"
        # Sugestões baseadas nos estabelecimentos que o usuário já reservou
        visited_establishment_ids = all_reservations.pluck(:establishment_id).uniq

        @suggestions = if visited_establishment_ids.any?
          # Sugere estabelecimentos similares (mesma categoria ou próximos)
          Establishment.where.not(id: visited_establishment_ids)
                      .where("rating >= ?", 4.0)
                      .order(rating: :desc)
                      .limit(10)
        else
          # Para usuários novos, sugere os mais bem avaliados
          Establishment.where("rating >= ?", 4.5).order(rating: :desc).limit(10)
        end
        @reservations = []
      else
        @reservations = all_reservations.includes(:establishment).order(date: :desc)
      end
    else
      # Para usuários não logados, sempre mostrar sugestões dos melhores restaurantes
      @reservations = []
      @suggestions = Establishment.where("rating >= ?", 4.0).order(rating: :desc).limit(10)
    end
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    @establishment = Establishment.find(params[:establishment_id]) if params[:establishment_id]
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)

    # Se usuário logado, associar à conta
    if current_user
      @reservation.user = current_user
      @reservation.email = current_user.email_address
    end

    respond_to do |format|
      if @reservation.save
        if current_user
          format.html { redirect_to @reservation, notice: "Reserva criada com sucesso!" }
        else
          format.html { redirect_to root_path, notice: "Reserva criada! Faça login para confirmar e gerenciar." }
        end
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: "Reservation was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy!

    respond_to do |format|
      format.html { redirect_to reservations_path, notice: "Reservation was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.expect(reservation: [ :establishment_id, :user_id, :email, :date, :people_count, :status ])
    end
end
