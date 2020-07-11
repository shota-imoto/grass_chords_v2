FactoryBot.define do
  factory :song do
    sequence(:id) {|n| n}
    sequence(:title) {|n| "Foggy Mountain Special#{n}"}
    jam {true}
    standard {true}
    beginner {false}
    vocal {false}
    instrumental {true}
    practice_songs_count {10}
    association :user

    factory :song2, class: Song do
      title {"Blue Ridge Cabin Home"}
      jam {true}
      standard {true}
      beginner {true}
      vocal {true}
      instrumental {false}
      practice_songs_count {10}
      association :user
    end

    trait :with_chords do
      after(:create) {|song| create_list(:chord, 5, song: song)}
    end

    trait :with_practice_songs do
      after(:create) {|song| create_list(:practice_song, 5, song: song)}
    end
  end
end

