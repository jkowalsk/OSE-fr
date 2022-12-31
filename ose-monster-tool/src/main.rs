use crate::monstre::Monstre;
use std::{fs,io};
use std::path::Path;
use std::fs::File;
use std::io::{BufWriter, Write};

mod monstre;
mod stats;
mod markdown_helper;

fn main() -> io::Result<()> {
    let mut paths: Vec<_> = fs::read_dir("../src/Monstres/liste")?.filter_map(|r| r.ok())
    .collect();
    paths.sort_by_key(|de| de.file_name());
    let outdir = "../latex/liste/";
    let mut all_monsters = BufWriter::new(File::create("../latex/all_monsters.tex").expect("Unable to create file"));
    let mut monsters = Vec::new();
    for path in paths {
        let path = path.path();
        monsters.append(&mut Monstre::from_md(path).unwrap());
    }

    for monster in monsters {
        let filename =  str::replace(&monster.nom.clone(), " ", "_");
        writeln!(all_monsters, "\\input{{liste/{}.tex}}", filename)?;
        let mut out = Path::new(outdir).join(filename);
        out.set_extension("tex");
        let f = File::create(out).expect("Unable to create file");
        let mut f = BufWriter::new(f);
        monster.to_tex(&mut f).expect("Unable to write file");
    }

    Ok(())
}
