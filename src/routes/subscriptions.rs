use actix_web::{web, HttpResponse};

#[derive(serde::Deserialize)]
pub struct FormData {
    name: String,
    email: String,
}

pub async fn subscribe(_form: web::Form<FormData>) -> HttpResponse {
    println!("{:?} contact at: {:?}", _form.name, _form.email);
    HttpResponse::Ok().finish()
}
