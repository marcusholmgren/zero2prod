use actix_web::{web, HttpResponse};
use chrono::Utc;
use sqlx::PgPool;
use uuid::Uuid;

#[derive(serde::Deserialize)]
pub struct FormData {
    name: String,
    email: String,
}

///
///
/// # Arguments
///
/// * `form`: FormData request
/// * `pool`: SQLx connection pool
///
/// returns: HttpResponse<BoxBody>
///
pub async fn subscribe(form: web::Form<FormData>, pool: web::Data<PgPool>) -> HttpResponse {
    let request_span = tracing::info_span!(
        "Adding a new subscriber.",
        subscriber_email = form.email,
        subscriber_name = form.name
    );
    let _request_span_guard = request_span.enter();
    match sqlx::query!(
        r#"
        INSERT INTO subscriptions (id, email, name, subscribed_at)
        VALUES ($1, $2, $3, $4)
        "#,
        Uuid::new_v4(),
        form.email,
        form.name,
        Utc::now()
    )
    .execute(pool.get_ref())
    .await
    {
        Ok(_) => {
            tracing::info!("New subscriber details have been saved to the database.");
            HttpResponse::Ok().finish()
        }
        Err(e) => {
            tracing::error!("Failed to execute query: {}", e);
            // match postgres duplicate error
            if e.to_string()
                .contains("duplicate key value violates unique constraint")
            {
                return HttpResponse::Conflict().finish();
            }
            HttpResponse::InternalServerError().finish()
        }
    }
}
