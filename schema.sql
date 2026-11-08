-- Studi kasus: Sistem Informasi Surat Desa (kop surat digital) - Desa Kedungrejo
CREATE TABLE desa (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  kecamatan VARCHAR(100),
  kabupaten VARCHAR(100),
  alamat TEXT
);

-- ONE TO ONE: desa <-> kop_surat
CREATE TABLE kop_surat (
  id SERIAL PRIMARY KEY,
  desa_id INT UNIQUE NOT NULL REFERENCES desa(id) ON DELETE CASCADE,
  logo_url TEXT,
  judul_kop VARCHAR(150) NOT NULL,
  alamat_kop TEXT
);

CREATE TABLE penduduk (
  id SERIAL PRIMARY KEY,
  desa_id INT NOT NULL REFERENCES desa(id),      -- ONE TO MANY: desa -> penduduk
  nik CHAR(16) UNIQUE NOT NULL,
  nama VARCHAR(100) NOT NULL,
  alamat TEXT,
  no_hp VARCHAR(20)
);

-- ONE TO ONE: penduduk <-> akun
CREATE TABLE akun (
  id SERIAL PRIMARY KEY,
  penduduk_id INT UNIQUE NOT NULL REFERENCES penduduk(id) ON DELETE CASCADE,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL
);

CREATE TABLE perangkat_desa (
  id SERIAL PRIMARY KEY,
  desa_id INT NOT NULL REFERENCES desa(id),
  nama VARCHAR(100) NOT NULL,
  jabatan VARCHAR(100) NOT NULL
);

CREATE TABLE jenis_surat (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,   -- mis. Surat Keterangan Domisili
  kode VARCHAR(20) UNIQUE NOT NULL
);

-- ONE TO MANY: jenis_surat -> surat, penduduk -> surat
CREATE TABLE surat (
  id SERIAL PRIMARY KEY,
  nomor_surat VARCHAR(50) UNIQUE NOT NULL,
  jenis_surat_id INT NOT NULL REFERENCES jenis_surat(id),
  penduduk_id INT NOT NULL REFERENCES penduduk(id),
  penandatangan_id INT REFERENCES perangkat_desa(id),
  perihal VARCHAR(200),
  tanggal DATE DEFAULT CURRENT_DATE,
  status VARCHAR(20) DEFAULT 'diajukan'
);

-- MANY TO MANY: surat <-> perangkat_desa (tembusan)
CREATE TABLE surat_tembusan (
  surat_id INT REFERENCES surat(id) ON DELETE CASCADE,
  perangkat_id INT REFERENCES perangkat_desa(id) ON DELETE CASCADE,
  PRIMARY KEY (surat_id, perangkat_id)
);

-- data contoh
INSERT INTO desa (nama, kecamatan, kabupaten) VALUES ('Kedungrejo','-','-');
