use std::net::TcpListener;
use zero2prod::startup::run;
use zero2prod::configuration::get_configuration;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    // Panic if we can't read configuration
    let configuration = get_configuration().expect("Failed to read configuration.");
    // Build our application with a connection pool to the database
    let address = format!("127.0.0.1:{}",  configuration.application_port);
    let listener = TcpListener::bind(address.clone())?;
    println!("Server listening on http://{}", address);
    run(listener)?.await
}
