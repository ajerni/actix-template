use actix_web::{web, App, HttpServer, Responder};

async fn index() -> impl Responder {
    "Hello from Actix Web!"
}

async fn health() -> impl Responder {
    "OK"
}

async fn name(path: web::Path<(String,)>) -> impl Responder {
    format!("Hello, {}!", path.0)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(web::scope("/api")
                .route("/name/{name}", web::get().to(name))
            )
            .route("/health", web::get().to(health))
            .route("/", web::get().to(index))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}

