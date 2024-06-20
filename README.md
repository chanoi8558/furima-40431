# テーブル設計

## Users テーブル

| Column             | Type    | Options                   |
|--------------------|---------|---------------------------|
| nickname           | string  | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |
| last_name          | string  | null: false               |
| first_name         | string  | null: false               |
| last_name_kana     | string  | null: false               |
| first_name_kana    | string  | null: false               |
| birthdate          | date    | null: false               |

### Association
- has_many :items
- has_many :purchases
- has_many :comments

## Items テーブル

| Column           | Type       | Options                        |
|------------------|------------|--------------------------------|
| image            | string     | null: false                    |
| name             | string     | null: false, limit: 40         |
| description      | text       | null: false, limit: 1000       |
| category_id      | integer    | null: false                    |
| condition_id     | integer    | null: false                    |
| postage_id       | integer    | null: false                    |
| prefecture_id    | integer    | null: false                    |
| handling_time_id | integer    | null: false                    |
| price            | integer    | null: false                    |
| user_id          | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_one :purchase
- has_many :comments

## Purchases テーブル

| Column  | Type       | Options                        |
|---------|------------|--------------------------------|
| user_id | references | null: false, foreign_key: true |
| item_id | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :item
- has_one :address

## Comments テーブル

| Column  | Type       | Options                        |
|---------|------------|--------------------------------|
| text    | text       | null: false                    |
| user_id | references | null: false, foreign_key: true |
| item_id | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :item

## Addresses テーブル

| Column       | Type       | Options                        |
|--------------|------------|--------------------------------|
| purchase_id  | references | null: false, foreign_key: true |
| postal_code  | string     | null: false                    |
| prefecture_id| integer    | null: false                    |
| city         | string     | null: false                    |
| address      | string     | null: false                    |
| building     | string     |                                |
| phone_number | string     | null: false                    |

### Association
- belongs_to :purchase