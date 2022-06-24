class AuthenticationController < ApplicationController

    # POST /auth/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, expire: time.strftime("%m-%d-%Y %H:%M"),
                        user: JSON(@user.to_json(methods: [:image_url]))}, status: :ok
        else
        render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end

    # POST /auth/signup
    def signup
        @user = User.new(user_params)
        @user.image.attach(params[:image])
        if @user.save
        render json: @user, status: :created
        else
        render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    private

    def login_params
        params.permit(:email, :password)
    end

    def user_params
        params.permit(
            :name, :email, :password,
        )
    end
end
