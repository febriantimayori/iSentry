import { Elysia, t } from "elysia";
import { login } from "../controllers/AuthControllers";
import jwt from "@elysiajs/jwt";
import { renew } from "../controllers/JWTControllers";

const AuthRoutes = new Elysia({ prefix: "/auth" })
    .use(
        jwt({
            name: "jwt",
            secret: "Skibidi_Sigma_Mewing_Rizz_Gyatt_inOhio_+1000Aura",
            exp: "1d",
        })
    )
    .use(
        jwt({
            name: "jwt_refresh",
            secret: "Skibidi_Sigma_Mewing_Rizz_Gyatt_inOhio_+1000Aura",
            exp: "30d",
        })
    )
    .post("/login", async ({ jwt, jwt_refresh, body }) => {
        return await login(
            body as {
                username: string;
                password: string;
            },
            jwt,
            jwt_refresh
        );
    })
    .post("/renew-token", async ({ jwt_refresh, body }) => {
        return await renew(body.refresh_token, jwt_refresh);
    }, {
        body: t.Object({
            refresh_token: t.String(),
        })
    });

export default AuthRoutes;
