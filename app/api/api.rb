# -*- encoding: utf-8 -*-
class API < Grape::API
  format :json

  resource :event_sets do
    desc 'イベントセットの一覧を返します'
    get do
      EventSet.includes(:events).all.page(1).as_json(methods: [:study_title, :drink_title])
    end

    desc '新規でイベントセットを作成します'
    params do
      requires :id_study, type: Integer, desc: '勉強会のzusaarのイベントID'
      requires :price_study, type: Integer, desc: '勉強会の参加費'
      requires :id_drink, type: Integer, desc: '懇親会のzusaarのイベントID'
      requires :price_drink, type: Integer, desc: '懇親会の参加費'
    end
    post do
      event_set = EventSet.create_or_update_by_zusaar(params[:id_study], params[:price_study], params[:id_drink], params[:price_drink])
      event_set.as_default_json
    end


    resource ':event_set_id' do
      desc 'イベントセットの詳細情報を返します'
      get do
        EventSet.find_by(id: params[:event_set_id]).as_default_json
      end

      params do
        requires :uuid, type: String, desc: 'NFCのUUID'
        optional :user_id, type: Integer, desc: 'ユーザID'
      end
      post 'attendance' do
        if !event_set = EventSet.find_by(id: params[:event_set_id])
          error!(400, 'イベントセットが見つかりません')
        end

        if nfc = Nfc.find_by(uuid: params[:uuid])
          # 参加にする
          event_set.add_attendance_user(nfc.user.id)
          AttendanceResponse.attendance
        elsif user_id = params[:user_id]
          if user = User.find_by(id: user_id)
            # NFC登録
            nfc = user.nfcs.create(uuid: params[:uuid])
            event_set.add_attendance_user(nfc.user.id)
            AttendanceResponse.attendance
          else
            error!(400, 'ユーザが見つかりません')
          end
        else
          AttendanceResponse.need_user_id
        end

      end
    end
  end
end
