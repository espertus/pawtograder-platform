import { useUserProfile } from "@/hooks/useUserProfiles";
import { HStack, Avatar, Text, VStack } from "@chakra-ui/react";
import { Tooltip } from "./tooltip";

export default function PersonName({ uid, size = "sm" }: { uid: string, size?: "2xs" | "xs" | "sm" | "md" | "lg" }) {
    const userProfile = useUserProfile(uid);
    return <Tooltip content={userProfile?.name}>
        <Avatar.Root size={size}>
            <Avatar.Image src={userProfile?.avatar_url} />
            <Avatar.Fallback>{userProfile?.name?.charAt(0)}</Avatar.Fallback>
        </Avatar.Root>
    </Tooltip>
}