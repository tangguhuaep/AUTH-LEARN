# Gunakan PHP 8.3
FROM php:8.3-fpm

# Install dependency sistem
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip git curl

# Install ekstensi PHP yang dibutuhkan Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy semua file Laravel ke container
COPY . .

# Install depedency Laravel
RUN composer install --no-dev --optimize-autoloader

# Generate storage link (kalau perlu)
RUN php artisan storage:link || true

# Expose port 80
EXPOSE 80

# Jalankan aplikasi Laravel
CMD php artisan serve --host 0.0.0.0 --port 80
