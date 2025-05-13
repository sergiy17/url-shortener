# URL Shortener | Rails

Analogue to https://bitly.com. The main idea is - users will be able to save a long link and use a shortened version instead. Basically visiting the shortened link will redirect you to the original one. Apart from the main functionality the link owner will be able to collect the statistics about how many visits that link had. The short link will not be accessible after 1 month from the last visit etc

<details>
  <summary>Project setup</summary>

1. Clone the repo with `git clone https://github.com/sergiy17/url-shortener.git`
2. `bundle && rails db:setup && rails s`
</details>

<details>
  <summary>Requests examples and screenshots</summary>

```
GET to http://127.0.0.1:3000/api/urls/uEkV2Hdyoi
```
<img width="1002" alt="Screenshot 2024-02-15 at 08 43 21" src="https://github.com/user-attachments/assets/36217d01-b8a4-45cb-949a-69272006f8f9">

```
GET to http://127.0.0.1:3000/api/urls
```
<img width="1002" alt="Screenshot 2024-02-15 at 08 43 21" src="https://github.com/user-attachments/assets/bc377edd-2a31-4576-a90b-24845f918fdd">

```
GET to http://127.0.0.1:3000/api/urls?page=2&per_page=2
```
<img width="1002" alt="Screenshot 2024-02-15 at 08 43 21" src="https://github.com/user-attachments/assets/f341326b-1cd2-40ea-8f5e-31c2de02520f">

</details>
