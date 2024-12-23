use std::{
    collections::HashMap,
    ops::{Deref, DerefMut},
};

use dlib_face_recognition::FaceEncoding;
use mysql::prelude::Queryable;

pub type Id = u64;

#[derive(Default)]
pub struct Faces(HashMap<Id, (Option<Id>, FaceEncoding)>);

#[derive(Default)]
pub struct Identities(HashMap<Id, (String, bool)>);

pub fn update(
    db_conn: &mut mysql::Conn,
    faces: &mut Faces,
    identities: &mut Identities,
) -> eyre::Result<()> {
    for row in db_conn.query::<(u64, Vec<u8>, Option<u64>, Option<String>, Option<bool>), _>(
        "
        SELECT faces.id as face_id, faces.embedding, identities.id, identities.name, identities.key
        FROM faces
        LEFT JOIN identities 
        ON faces.identity = identities.id;
    ",
    )? {
        let (face_id, embedding, identity_id, name, key) = row;
        let Ok(embedding) = bincode::deserialize::<Vec<f64>>(&embedding).inspect_err(|_e| {
            // tracing::warn!("Embedding is not [f64; 128] for face_id {face_id} with error: {_e}");
        }) else {
            continue;
        };
        if embedding.len() != 128 {
            // tracing::warn!("Embedding is not [f64; 128] for face_id: {face_id}");
            continue;
        }
        let Ok(embedding) = FaceEncoding::from_vec(&embedding) else {
            // tracing::warn!("Can't get FaceEncoding from embeding in database for face_id {face_id}");
            continue;
        };
        faces.insert(face_id, identity_id, embedding);
        if let Some(id) = identity_id {
            identities.insert(id, (name.unwrap(), key.unwrap()));
        }
    }
    Ok(())
}

impl Faces {
    pub fn insert(&mut self, id: Id, identity_id: Option<Id>, face: FaceEncoding) {
        self.0.insert(id, (identity_id, face));
    }

    /// returns (face_id, identity_id)
    pub fn identity(&self, other: &FaceEncoding) -> (Option<Id>, Option<Id>) {
        for (face_id, (identity, face)) in &self.0 {
            if face.distance(other) < 0.6 {
                return (Some(*face_id), *identity);
            }
        }
        (None, None)
    }
}

impl Deref for Identities {
    type Target = HashMap<Id, (String, bool)>;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for Identities {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}
