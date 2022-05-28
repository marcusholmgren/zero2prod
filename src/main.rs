use std::net::TcpListener;
use zero2prod::run;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8000")?;
    let port = listener.local_addr().unwrap().port();
    println!("Server listening on http://127.0.0.1:{}", port);
    run(listener)?.await
}
